import 'service.dart';

class ServiceBooking {
  final String bookingId;
  final BeautyService service;
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
    required this.service,
    required this.date,
    required this.timeSlot,
    required this.locationType,
    this.address,
    this.selectedArtist,
    required this.totalAmount,
    this.status = "Confirmed",
    required this.createdAt,
  });
}
