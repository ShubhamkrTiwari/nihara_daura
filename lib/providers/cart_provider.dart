import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartState {
  final List<CartItem> items;
  final String? appliedPromoCode;
  final double discountPercent;

  const CartState({
    this.items = const [],
    this.appliedPromoCode,
    this.discountPercent = 0.0,
  });

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount => subtotal * (discountPercent / 100);

  double get deliveryFee => subtotal > 100 || subtotal == 0 ? 0.0 : 15.0;

  double get total => subtotal - discountAmount + deliveryFee;

  CartState copyWith({
    List<CartItem>? items,
    String? appliedPromoCode,
    double? discountPercent,
  }) {
    return CartState(
      items: items ?? this.items,
      appliedPromoCode: appliedPromoCode ?? this.appliedPromoCode,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(Product product, {required String variant, String? size, int quantity = 1}) {
    final existingIndex = state.items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedVariant == variant &&
          item.selectedSize == size,
    );

    if (existingIndex >= 0) {
      final updated = List<CartItem>.from(state.items);
      final current = updated[existingIndex];
      updated[existingIndex] = current.copyWith(
        quantity: current.quantity + quantity,
      );
      state = state.copyWith(items: updated);
    } else {
      final newItem = CartItem(
        product: product,
        quantity: quantity,
        selectedVariant: variant,
        selectedSize: size,
      );
      state = state.copyWith(items: [...state.items, newItem]);
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index < 0 || index >= state.items.length) return;
    if (newQuantity <= 0) {
      removeItem(index);
      return;
    }
    final updated = List<CartItem>.from(state.items);
    updated[index] = updated[index].copyWith(quantity: newQuantity);
    state = state.copyWith(items: updated);
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;
    final updated = List<CartItem>.from(state.items)..removeAt(index);
    state = state.copyWith(items: updated);
  }

  bool applyPromoCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    if (cleanCode == 'NIHARA10') {
      state = state.copyWith(appliedPromoCode: 'NIHARA10', discountPercent: 10.0);
      return true;
    } else if (cleanCode == 'GLOW20') {
      state = state.copyWith(appliedPromoCode: 'GLOW20', discountPercent: 20.0);
      return true;
    }
    return false;
  }

  void removePromoCode() {
    state = state.copyWith(appliedPromoCode: null, discountPercent: 0.0);
  }

  void clearCart() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});
