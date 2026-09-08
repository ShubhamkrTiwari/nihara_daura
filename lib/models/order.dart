import 'cart_item.dart';

class CustomerOrder {
  final String orderId;
  final List<CartItem> items;
  final double subtotal;
  final double discount;
  final double totalAmount;
  final DateTime orderDate;
  final String status; // "Processing", "Shipped", "Delivered", "Cancelled"
  final String shippingAddress;
  final String paymentMethod;

  const CustomerOrder({
    required this.orderId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
  });
}
