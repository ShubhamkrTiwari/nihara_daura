import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/cart_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/nihara_app_bar.dart';
import '../widgets/auth_guard_dialog.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartProvider);

    return Scaffold(
      appBar: const NiharaAppBar(
        title: 'Shopping Bag',
        showBackButton: true,
        showCartIcon: false,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: cartState.items.isEmpty
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
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Your Shopping Bag is Empty',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Discover our luxury collections and add your favourites.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Explore Nihara Products',
                      onPressed: () => context.go('/products'),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Item List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartState.items.length,
                      itemBuilder: (context, index) {
                        final item = cartState.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  item.product.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Variant: ${item.selectedVariant}${item.selectedSize != null ? " • Size: ${item.selectedSize}" : ""}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '₹${item.totalPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Quantity Adjuster & Remove
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                                    onPressed: () {
                                      ref.read(cartProvider.notifier).removeItem(index);
                                    },
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.cardBg,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(cartProvider.notifier).updateQuantity(index, item.quantity - 1);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.remove, size: 14),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                          child: Text(
                                            '${item.quantity}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            ref.read(cartProvider.notifier).updateQuantity(index, item.quantity + 1);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(6),
                                            child: Icon(Icons.add, size: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Promo Code Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Promo Code / Voucher',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _promoController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter NIHARA10 or GLOW20',
                                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () {
                                  final success = ref.read(cartProvider.notifier).applyPromoCode(_promoController.text);
                                  if (success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Promo Code Applied Successfully!'), backgroundColor: AppColors.secondary),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid Code. Try NIHARA10 or GLOW20'), backgroundColor: Colors.redAccent),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.secondary,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Apply', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                          if (cartState.appliedPromoCode != null) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Applied Code: ${cartState.appliedPromoCode} (${cartState.discountPercent.toInt()}% Off)',
                                  style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12),
                                ),
                                GestureDetector(
                                  onTap: () => ref.read(cartProvider.notifier).removePromoCode(),
                                  child: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Order Summary Calculation
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _buildRow('Subtotal', '₹${cartState.subtotal.toStringAsFixed(0)}'),
                          if (cartState.discountAmount > 0)
                            _buildRow('Promo Discount', '-₹${cartState.discountAmount.toStringAsFixed(0)}', isDiscount: true),
                          _buildRow('Delivery Fee', cartState.deliveryFee == 0 ? 'FREE' : '₹${cartState.deliveryFee.toStringAsFixed(0)}'),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              Text(
                                '₹${cartState.total.toStringAsFixed(0)}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    CustomButton(
                      text: 'Proceed to Checkout',
                      width: double.infinity,
                      onPressed: () async {
                        if (await AuthGuard.checkAuth(context, ref)) {
                          if (context.mounted) {
                            context.push('/checkout');
                          }
                        }
                      },
                      icon: Icons.lock_outline_rounded,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildRow(String label, String value, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: isDiscount ? AppColors.secondary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
