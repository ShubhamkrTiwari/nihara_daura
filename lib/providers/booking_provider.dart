import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking.dart';
import '../models/service.dart';
import 'service_provider.dart';

class BookingDraft {
  final List<BeautyService> selectedServices;
  final DateTime? date;
  final String? timeSlot;
  final String locationType; // "At Salon", "At Home Service"
  final String? address;
  final Artist? selectedArtist;

  const BookingDraft({
    this.selectedServices = const [],
    this.date,
    this.timeSlot,
    this.locationType = "At Salon",
    this.address,
    this.selectedArtist,
  });

  bool get isValid => selectedServices.isNotEmpty && date != null && timeSlot != null;

  double get servicesSubtotal {
    return selectedServices.fold(0.0, (sum, s) => sum + s.price);
  }

  double get extraTravelCharge => locationType == "At Home Service" ? 500.0 : 0.0;

  double get totalAmount => servicesSubtotal + extraTravelCharge;

  BookingDraft copyWith({
    List<BeautyService>? selectedServices,
    DateTime? date,
    String? timeSlot,
    String? locationType,
    String? address,
    Artist? selectedArtist,
  }) {
    return BookingDraft(
      selectedServices: selectedServices ?? this.selectedServices,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      locationType: locationType ?? this.locationType,
      address: address ?? this.address,
      selectedArtist: selectedArtist ?? this.selectedArtist,
    );
  }
}

class BookingNotifier extends StateNotifier<List<ServiceBooking>> {
  BookingNotifier()
      : super([
          ServiceBooking(
            bookingId: 'BK-89021',
            services: [mockBeautyServices[0], mockBeautyServices[2]],
            date: DateTime.now().add(const Duration(days: 3)),
            timeSlot: '11:00 AM',
            locationType: 'At Salon',
            selectedArtist: mockArtists[0],
            totalAmount: 22300.00,
            status: 'Upcoming',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
          ServiceBooking(
            bookingId: 'BK-88412',
            services: [mockBeautyServices[2]],
            date: DateTime.now().subtract(const Duration(days: 12)),
            timeSlot: '03:00 PM',
            locationType: 'At Home Service',
            address: '42 Lotus Heights, Jubilee Hills, Hyderabad',
            selectedArtist: mockArtists[1],
            totalAmount: 4300.00,
            status: 'Completed',
            createdAt: DateTime.now().subtract(const Duration(days: 15)),
          ),
        ]);

  ServiceBooking createBooking(BookingDraft draft) {
    final newBooking = ServiceBooking(
      bookingId: 'BK-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      services: List.from(draft.selectedServices),
      date: draft.date!,
      timeSlot: draft.timeSlot!,
      locationType: draft.locationType,
      address: draft.address ?? '12 Bandra West, Mumbai, Maharashtra 400050',
      selectedArtist: draft.selectedArtist,
      totalAmount: draft.totalAmount,
      status: 'Confirmed',
      createdAt: DateTime.now(),
    );

    state = [newBooking, ...state];
    return newBooking;
  }

  void cancelBooking(String bookingId) {
    state = state.map((b) {
      if (b.bookingId == bookingId) {
        return ServiceBooking(
          bookingId: b.bookingId,
          services: b.services,
          date: b.date,
          timeSlot: b.timeSlot,
          locationType: b.locationType,
          address: b.address,
          selectedArtist: b.selectedArtist,
          totalAmount: b.totalAmount,
          status: 'Cancelled',
          createdAt: b.createdAt,
        );
      }
      return b;
    }).toList();
  }
}

final bookingDraftProvider = StateProvider<BookingDraft>((ref) => const BookingDraft());

final bookingsProvider = StateNotifierProvider<BookingNotifier, List<ServiceBooking>>((ref) {
  return BookingNotifier();
});
