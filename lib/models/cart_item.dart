import 'product.dart';

class CartItem {
  final Product product;
  int quantity;
  final String selectedVariant;
  final String? selectedSize;

  CartItem({
    required this.product,
    this.quantity = 1,
    required this.selectedVariant,
    this.selectedSize,
  });

  double get totalPrice => product.price * quantity;

  CartItem copyWith({
    Product? product,
    int? quantity,
    String? selectedVariant,
    String? selectedSize,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      selectedSize: selectedSize ?? this.selectedSize,
    );
  }
}
