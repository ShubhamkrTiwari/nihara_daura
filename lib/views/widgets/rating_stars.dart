import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double iconSize;
  final TextStyle? textStyle;

  const RatingStars({
    super.key,
    required this.rating,
    this.reviewCount,
    this.iconSize = 14.0,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star_rounded,
          color: AppColors.starYellow,
          size: iconSize,
        ),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: textStyle ??
              const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 3),
          Text(
            '($reviewCount)',
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary.withValues(alpha: 0.8),
            ),
          ),
        ],
      ],
    );
  }
}
