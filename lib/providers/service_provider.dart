import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service.dart';

const mockArtists = <Artist>[
  Artist(
    id: 'a1',
    name: 'Priya Sharma',
    role: 'Master Bridal Makeup Artist',
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=400&q=80',
  ),
  Artist(
    id: 'a2',
    name: 'Ananya Verma',
    role: 'Senior Nail Art Specialist',
    rating: 4.8,
    imageUrl: 'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=400&q=80',
  ),
  Artist(
    id: 'a3',
    name: 'Meera Kapoor',
    role: 'Aroma Therapy & Spa Therapist',
    rating: 4.9,
    imageUrl: 'https://images.unsplash.com/photo-1567532939604-b6b5b0db2604?w=400&q=80',
  ),
  Artist(
    id: 'a4',
    name: 'Rohan Malhotra',
    role: 'Celebrity Hair & Drape Stylist',
    rating: 5.0,
    imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
  ),
];

final mockBeautyServices = <BeautyService>[
  BeautyService(
    id: 's1',
    title: 'Royal Bridal Glow & Makeup Package',
    category: 'Makeup',
    duration: '180 Mins',
    price: 350.00,
    rating: 4.95,
    reviewCount: 310,
    imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?w=800&q=80',
    description: 'Complete luxury bridal transformation including HD airbrush makeup, saree/lehenga saree drapes, hair styling, skin prep, and luxury lashes.',
    includes: [
      'HD Airbrush / Waterproof Makeup',
      'Custom Lash Extensions & Setting',
      'Hairstyling & Floral Accessory Setting',
      'Lehenga / Dupatta Draping',
      'Complimentary Touch-Up Kit'
    ],
    availableArtists: [mockArtists[0], mockArtists[3]],
  ),
  BeautyService(
    id: 's2',
    title: 'Celebrity Glam Party Makeup',
    category: 'Makeup',
    duration: '90 Mins',
    price: 120.00,
    rating: 4.88,
    reviewCount: 195,
    imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
    description: 'Radiant, red-carpet ready makeup tailored to your outfit and event style. Includes soft contouring, smoky or shimmer eye design, and satin lip color.',
    includes: [
      'Hydrating Skin Prep & Primer',
      'Eye Makeup with Shimmer/Glints',
      'Lashes & Waterproof Setting Spray',
      'Hair Blowdry or Soft Waves'
    ],
    availableArtists: [mockArtists[0], mockArtists[1]],
  ),
  BeautyService(
    id: 's3',
    title: 'Rose Quartz Luxe Gel Nail Extensions',
    category: 'Nails',
    duration: '120 Mins',
    price: 85.00,
    rating: 4.90,
    reviewCount: 240,
    imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800&q=80',
    description: 'Handcrafted acrylic or soft gel extensions with custom nail art, gold foil foil accents, or French chrome finish.',
    includes: [
      'Full Set Extension (Almond/Coffin/Stiletto)',
      'Cuticle Care & Hand Massage',
      '2 Accent Nails Hand-painted Art / Chrome',
      'UV Top Coat Seal'
    ],
    availableArtists: [mockArtists[1]],
  ),
  BeautyService(
    id: 's4',
    title: 'Nihara Signature At-Home Glow Spa',
    category: 'Home Spa',
    duration: '100 Mins',
    price: 150.00,
    rating: 4.92,
    reviewCount: 168,
    imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?w=800&q=80',
    description: 'Indulgent aromatic facial and hot oil scalp massage conducted in the comfort of your home using Nihara essential oils and organic botanicals.',
    includes: [
      'Aromatherapy Herbal Steaming',
      'Rose Quartz Face Massage & Gua Sha',
      'Kansa Wand Scalp Treatment',
      'Deep Cleansing Gold Mask'
    ],
    availableArtists: [mockArtists[2]],
  ),
  BeautyService(
    id: 's5',
    title: 'Bridal Jewellery & Styling Consultation',
    category: 'Jewellery',
    duration: '60 Mins',
    price: 60.00,
    rating: 4.85,
    reviewCount: 82,
    imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
    description: 'Personalized styling session with Nihara jewellery curators to match your wedding attire, necklines, and color theme.',
    includes: [
      'Virtual or In-Salon Fitting Session',
      'Color & Neckline Matching',
      'Custom Earring & Mathapatti Pairing',
      'Includes \$50 Credit Towards Jewellery Purchase'
    ],
    availableArtists: [mockArtists[0], mockArtists[3]],
  ),
];

final servicesProvider = Provider<List<BeautyService>>((ref) {
  return mockBeautyServices;
});

final selectedCategoryServicesProvider = Provider.family<List<BeautyService>, String>((ref, category) {
  final services = ref.watch(servicesProvider);
  if (category == 'All') return services;
  return services.where((s) => s.category.toLowerCase() == category.toLowerCase()).toList();
});
