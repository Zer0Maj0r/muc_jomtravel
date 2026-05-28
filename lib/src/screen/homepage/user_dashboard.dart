import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muc_jomtravel/src/model/models.dart';
import 'package:muc_jomtravel/src/screen/package/package_card.dart';
import 'package:muc_jomtravel/src/service/services.dart';
import 'package:muc_jomtravel/src/shared/theme/app_colors.dart';

class UserDashboardScreen extends StatefulWidget {
  const UserDashboardScreen({super.key});

  @override
  State<UserDashboardScreen> createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final UserService _userService = UserService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;
  late Future<List<Package>> _packagesFuture;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  final List<String> _filterOptions = [
    'All',
    'Heritage',
    'Beach',
    'Waterpark',
    'Food',
    'Family',
  ];

  @override
  void initState() {
    super.initState();
    _packagesFuture = _userService.getPackages();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  List<Package> _applyFilters(List<Package> packages) {
    final query = _searchQuery.trim().toLowerCase();
    final filtered = packages.where((pkg) {
      final matchesSearch = query.isEmpty ||
          pkg.title.toLowerCase().contains(query) ||
          pkg.location.toLowerCase().contains(query) ||
          pkg.description.toLowerCase().contains(query);

      final matchesFilter = _selectedFilter == 'All' ||
          pkg.title.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
          pkg.description.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
          pkg.location.toLowerCase().contains(_selectedFilter.toLowerCase()) ||
          pkg.activities.any((activity) =>
              activity.toLowerCase().contains(_selectedFilter.toLowerCase()));

      return matchesSearch && matchesFilter;
    }).toList();

    return filtered.take(10).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('JomTravel', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Welcome Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back,',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentUser?.displayName ?? 'Traveler',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Where to next?',
                          hintStyle: const TextStyle(color: AppColors.textLight),
                          border: InputBorder.none,
                          icon: const Icon(Icons.search, color: AppColors.primary),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: AppColors.primary),
                                  onPressed: () {
                                    _searchController.clear();
                                    _onSearchChanged('');
                                  },
                                )
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// Section Title
              const Text(
                'Top 10 Popular Packages',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _filterOptions.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final option = _filterOptions[index];
                    final selected = option == _selectedFilter;
                    return ChoiceChip(
                      label: Text(option),
                      selected: selected,
                      onSelected: (_) => _onFilterChanged(option),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.cardBackground,
                      labelStyle: TextStyle(
                        color: selected ? Colors.white : AppColors.textPrimary,
                        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),

              /// Packages Grid
              FutureBuilder<List<Package>>(
                future: _packagesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: AppColors.primary));
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: AppColors.error)));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No active packages found.', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    );
                  }

                  final packages = _applyFilters(snapshot.data!);

                  if (packages.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('No packages match your filters.', style: TextStyle(color: AppColors.textSecondary)),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: packages.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final package = packages[index];
                      return PackageCard(package: package);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

