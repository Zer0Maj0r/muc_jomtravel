import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:muc_jomtravel/src/model/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<AppUser?> getUserData(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();

    if (!doc.exists) return null;
    //print(doc.data());
    return AppUser.fromMap(doc.data()!);
  }

  Future<List<Package>> getPackages() async {
    final snapshot = await _db
        .collection('packages')
        .where('is_active', isEqualTo: true)
        .get();
    final packages = snapshot.docs.map((doc) => Package.fromMap(doc.data())).toList();
    packages.sort(_comparePackagesByPopularity);
    return packages;
  }

  Future<List<Package>> searchPackages(String query) async {
    // Fetch all active packages first (for robust client-side filtering)
    // Firestore lacks native case-insensitive substrings search
    final allPackages = await getPackages();

    if (query.isEmpty) {
      return allPackages;
    }

    final lowerQuery = query.toLowerCase();
    final results = allPackages.where((pkg) {
      final title = pkg.title.toLowerCase();
      final location = pkg.location.toLowerCase();
      return title.contains(lowerQuery) || location.contains(lowerQuery);
    }).toList();
    results.sort(_comparePackagesByPopularity);
    return results;
  }

  int _comparePackagesByPopularity(Package a, Package b) {
    final scoreComparison = b.popularityScore.compareTo(a.popularityScore);
    if (scoreComparison != 0) {
      return scoreComparison;
    }
    return b.createdAt.compareTo(a.createdAt);
  }

  Future<void> savePendingProfile({required String name}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_name', name);
  }

  Future<String> returnPendingProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString('pending_name');

    // 🔴 Clear immediately after reading
    await prefs.remove('pending_name');

    return name ?? '';
  }
}
