import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/nihara_app_bar.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistProductsProvider);

    return Scaffold(
      appBar: const NiharaAppBar(
        title: 'My Wishlist',
        showBackButton: false,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: wishlistItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: AppColors.goldLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border_rounded,
                        size: 64,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Wishlist is Empty',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap heart icon on products to save them for later.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Explore Nihara Collections',
                      onPressed: () => context.go('/products'),
                    ),
                  ],
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: wishlistItems[index],
                    width: double.infinity,
                  );
                },
              ),
      ),
    );
  }
}
