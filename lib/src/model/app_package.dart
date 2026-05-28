import 'package:cloud_firestore/cloud_firestore.dart';

class Package {
  final String packageId;
  final String title;
  final String description;
  final String location;
  final String duration;
  final double priceAdult;
  final double priceChild;
  final String openingHours;
  final String closingHours;
  final String openingDay;
  final String closingDay;
  final List<String> activities;
  final String contactNumber;
  final List<String> image;
  final bool isActive;
  final int popularityScore;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  Package({
    required this.packageId,
    required this.title,
    required this.description,
    required this.location,
    required this.duration,
    required this.priceAdult,
    required this.priceChild,
    required this.openingHours,
    required this.closingHours,
    required this.openingDay,
    required this.closingDay,
    required this.activities,
    required this.contactNumber,
    required this.image,
    required this.isActive,
    required this.popularityScore,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Package.fromMap(Map<String, dynamic> map) {
    return Package(
      packageId: map['package_id'],
      title: map['title'],
      description: map['description'],
      location: map['location'],
      openingHours: map['opening_hours'],
      closingHours: map['closing_hours'],
      openingDay: map['opening_day'],
      closingDay: map['closing_day'],
      duration: map['duration'],
      activities: List<String>.from(map['activities'] ?? []),
      priceAdult: map['price_adult'].toDouble(),
      priceChild: map['price_child'].toDouble(),
      contactNumber: map['contact_number'],
      image: List<String>.from(map['image_url'] ?? []),
      isActive: map['is_active'],
      popularityScore: ((map['popularity_score'] ?? 0) as num).toInt(),
      createdAt: map['created_at'],
      updatedAt: map['updated_at'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'package_id': packageId,
      'title': title,
      'description': description,
      'location': location,
      'opening_hours': openingHours,
      'closing_hours': closingHours,
      'opening_day': openingDay,
      'closing_day': closingDay,
      'duration': duration,
      'activities': activities,
      'price_adult': priceAdult,
      'price_child': priceChild,
      'contact_number': contactNumber,
      'image_url': image,
      'is_active': isActive,
      'popularity_score': popularityScore,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

