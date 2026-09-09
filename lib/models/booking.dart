import 'service.dart';

class ServiceBooking {
  final String bookingId;
  final List<BeautyService> services;
  final DateTime date;
  final String timeSlot;
  final String locationType; // "Salon Visit" or "At Home Service"
  final String? address;
  final Artist? selectedArtist;
  final double totalAmount;
  final String status; // "Confirmed", "Upcoming", "Completed", "Cancelled"
  final DateTime createdAt;

  const ServiceBooking({
    required this.bookingId,
    required this.services,
    required this.date,
    required this.timeSlot,
    required this.locationType,
    this.address,
    this.selectedArtist,
    required this.totalAmount,
    this.status = "Confirmed",
    required this.createdAt,
  });

  BeautyService get primaryService => services.isNotEmpty ? services.first : mockBeautyServicesFallback;

  String get servicesSummaryTitle {
    if (services.isEmpty) return 'Beauty Service';
    if (services.length == 1) return services.first.title;
    return '${services.first.title} + ${services.length - 1} more';
  }
}

const mockBeautyServicesFallback = BeautyService(
  id: 'fallback',
  title: 'Beauty Styling Service',
  category: 'Makeup',
  duration: '60 Mins',
  price: 2500.0,
  rating: 4.9,
  reviewCount: 50,
  imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
  description: 'Luxury styling service.',
  includes: [],
  availableArtists: [],
);
