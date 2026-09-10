import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/service.dart';
import '../../theme/app_theme.dart';
import '../../providers/booking_provider.dart';
import 'rating_stars.dart';
import 'auth_guard_dialog.dart';

class ServiceCard extends ConsumerWidget {
  final BeautyService service;

  const ServiceCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(18)),
              child: SizedBox(
                width: 110,
                child: Image.network(
                  service.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBg,
                    child: const Icon(Icons.face_retouching_natural_outlined, color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                gradient: AppColors.softGoldGradient,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Text(
                                service.category,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textSecondary),
                                const SizedBox(width: 3),
                                Text(
                                  service.duration,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          service.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        RatingStars(
                          rating: service.rating,
                          reviewCount: service.reviewCount,
                          iconSize: 12,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₹${service.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (await AuthGuard.checkAuth(context, ref)) {
                              ref.read(bookingDraftProvider.notifier).state =
                                  BookingDraft(selectedServices: [service]);
                              if (context.mounted) {
                                context.push('/book');
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              gradient: AppColors.goldGradient,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.secondary.withValues(alpha: 0.25),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            child: const Text(
                              'Book Now',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
