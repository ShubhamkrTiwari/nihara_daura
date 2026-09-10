import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import 'rating_stars.dart';
import 'auth_guard_dialog.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  final double width;

  const ProductCard({
    super.key,
    required this.product,
    this.width = 170,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final isFav = wishlist.contains(product.id);

    return GestureDetector(
      onTap: () => context.push('/product/${product.id}'),
      child: Container(
        width: width,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: AppColors.cardBg,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ),

                // Golden Discount Badge
                if (product.hasDiscount)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        '${product.discountPercentage}% OFF',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                // Wishlist Button Guarded
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () async {
                      if (await AuthGuard.checkAuth(context, ref)) {
                        ref.read(wishlistProvider.notifier).toggleFavorite(product.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.92),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isFav ? AppColors.secondary : AppColors.textSecondary,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 8, 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 1),
                        RatingStars(
                          rating: product.rating,
                          reviewCount: product.reviewCount,
                          iconSize: 11,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '₹${product.price.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (product.hasDiscount)
                                Text(
                                  '₹${product.originalPrice!.toStringAsFixed(0)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: AppColors.textSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Add to Cart Button Guarded
                        GestureDetector(
                          onTap: () async {
                            if (await AuthGuard.checkAuth(context, ref)) {
                              ref.read(cartProvider.notifier).addItem(
                                    product,
                                    variant: product.variants.first,
                                    size: product.sizes?.first,
                                  );
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} added to cart'),
                                    backgroundColor: AppColors.secondary,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              gradient: AppColors.softGoldGradient,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 15,
                              color: AppColors.secondary,
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
