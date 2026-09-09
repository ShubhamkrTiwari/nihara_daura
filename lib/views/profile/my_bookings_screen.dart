import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../providers/booking_provider.dart';
import '../widgets/nihara_app_bar.dart';

class MyBookingsScreen extends ConsumerWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingsProvider);

    return Scaffold(
      appBar: const NiharaAppBar(
        title: 'My Appointments',
        showBackButton: true,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: bookings.isEmpty
            ? const Center(child: Text('No appointments booked yet.'))
            : ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              booking.bookingId,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.secondary),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: booking.status == 'Confirmed' || booking.status == 'Upcoming'
                                    ? AppColors.roseLight
                                    : booking.status == 'Completed'
                                        ? Colors.green.shade50
                                        : Colors.red.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                booking.status,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: booking.status == 'Confirmed' || booking.status == 'Upcoming'
                                      ? AppColors.secondary
                                      : booking.status == 'Completed'
                                          ? Colors.green.shade700
                                          : Colors.redAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(booking.primaryService.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.servicesSummaryTitle,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  Text(
                                    'Artist: ${booking.selectedArtist?.name ?? "Assigned Specialist"}',
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(DateFormat('EEE, MMM d, yyyy').format(booking.date), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 14, color: AppColors.secondary),
                                const SizedBox(width: 4),
                                Text(booking.timeSlot, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 14, color: AppColors.secondary),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                '${booking.locationType} - ${booking.address ?? "Bandra Flagship Salon"}',
                                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        if (booking.status == 'Confirmed' || booking.status == 'Upcoming') ...[
                          const Divider(height: 20),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                ref.read(bookingsProvider.notifier).cancelBooking(booking.bookingId);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Appointment Cancelled')),
                                );
                              },
                              child: const Text('Cancel Appointment', style: TextStyle(color: Colors.redAccent, fontSize: 12)),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
