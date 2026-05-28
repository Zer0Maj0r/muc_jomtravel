import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

Future<void> insertKelantanPackages() async {
  final firestore = FirebaseFirestore.instance;
  final batch = firestore.batch();
  final now = Timestamp.now();

  final packages = [
    {
      "title": "Stadthuys & Red Square Heritage Walk",
      "description":
          "Guided heritage walk around Melaka’s iconic Dutch-era landmarks and UNESCO sites.",
      "location": "Stadthuys, Banda Hilir, Melaka",
      "opening_hours": "09:00",
      "closing_hours": "17:00",
      "opening_day": "Monday",
      "closing_day": "Sunday",
      "duration": "2 hours",
      "activities": [
        "Historical walking tour",
        "Dutch architecture exploration",
        "Photography session",
      ],
      "price_adult": 45.0,
      "price_child": 25.0,
      "contact_number": "01123456789",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729347/Dutch-square-2_gqtbdy.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729346/Dutch-square-3_sr8nuo.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729346/Dutch-square-1_h9dlvz.webp",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
    {
      "title": "Jonker Street Night Market Experience",
      "description":
          "Evening food and culture exploration at Melaka’s most famous night market.",
      "location": "Jonker Street, Melaka",
      "opening_hours": "18:00",
      "closing_hours": "23:00",
      "opening_day": "Friday",
      "closing_day": "Sunday",
      "duration": "2.5 hours",
      "activities": [
        "Street food tasting",
        "Cultural shopping",
        "Local street performances",
      ],
      "price_adult": 55.0,
      "price_child": 35.0,
      "contact_number": "0129876543",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729350/Jonker_Street_Night_Market_Experience-1_zlpapb.jpg",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729346/Jonker_Street_Night_Market_Experience-2_ncssqx.jpg",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
    {
      "title": "Melaka River Cruise Tour",
      "description":
          "Relaxing river cruise showcasing Melaka’s heritage murals and riverside history.",
      "location": "Melaka River Cruise Jetty, Melaka",
      "opening_hours": "10:00",
      "closing_hours": "22:00",
      "opening_day": "Monday",
      "closing_day": "Sunday",
      "duration": "1 hour",
      "activities": [
        "River cruise",
        "City sightseeing",
        "Night light photography",
      ],
      "price_adult": 60.0,
      "price_child": 40.0,
      "contact_number": "0133332211",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729350/Melaka_River_Cruise_Tour-3_q8kzms.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729349/Melaka-River-Cruise-2_ew3npk.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729347/Melaka-River-cruise-1_qcz130.webp",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
    {
      "title": "Legoland Malaysia Theme Park Day Pass",
      "description":
          "Full-day access to Legoland Malaysia with rides, shows, and attractions.",
      "location": "Legoland Malaysia, Iskandar Puteri, Johor",
      "opening_hours": "10:00",
      "closing_hours": "18:00",
      "opening_day": "Monday",
      "closing_day": "Sunday",
      "duration": "8 hours",
      "activities": ["Theme park rides", "Live shows", "Family attractions"],
      "price_adult": 180.0,
      "price_child": 140.0,
      "contact_number": "0142223344",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729349/Legoland-2_h1pvay.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729348/Legoland-1_xujwnx.webp",
        "",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
    {
      "title": "Desaru Coast Beach & Waterpark Experience",
      "description":
          "Beach relaxation combined with waterpark fun at Desaru Coast.",
      "location": "Desaru Coast, Kota Tinggi, Johor",
      "opening_hours": "09:00",
      "closing_hours": "18:00",
      "opening_day": "Monday",
      "closing_day": "Sunday",
      "duration": "6 hours",
      "activities": [
        "Beach leisure",
        "Waterpark activities",
        "Family recreation",
      ],
      "price_adult": 150.0,
      "price_child": 110.0,
      "contact_number": "0155556677",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729360/Desaru-1_pperky.jpg",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729350/Desaru-3_ptdsih.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729349/Desaru-2_h2vmxd.webp",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
    {
      "title": "Johor Bahru Heritage & Food Tour",
      "description":
          "Discover Johor Bahru’s heritage sites while sampling famous local dishes.",
      "location": "Johor Bahru City Centre, Johor",
      "opening_hours": "10:00",
      "closing_hours": "16:00",
      "opening_day": "Tuesday",
      "closing_day": "Sunday",
      "duration": "3 hours",
      "activities": [
        "City heritage tour",
        "Local food tasting",
        "Cultural explanation",
      ],
      "price_adult": 65.0,
      "price_child": 40.0,
      "contact_number": "0168889900",
      "image_url": [
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729350/Johor_Bahru_Heritage_Food_Tour-1_b2s3jb.webp",
        "https://res.cloudinary.com/dijcgzy3v/image/upload/v1767729349/Johor_Bahru_Heritage_Food_Tour-2_xfxj0b.webp",
      ],
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    },
  ];

  for (final pkg in packages) {
    final String packageId = Uuid().v4();
    final docRef = firestore.collection('packages').doc(packageId);

    batch.set(docRef, {
      'package_id': packageId,
      ...pkg,
      'popularity_score': pkg['popularity_score'] ?? 0,
      'is_active': true,
      'created_at': now,
      'updated_at': now,
    });
  }

  //await batch.commit();
}


  //await batch.commit();
}
