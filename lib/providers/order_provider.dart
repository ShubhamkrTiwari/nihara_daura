import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/cart_item.dart';
import 'product_provider.dart';

class OrderNotifier extends StateNotifier<List<CustomerOrder>> {
  OrderNotifier()
      : super([
          CustomerOrder(
            orderId: 'NIH-948201',
            items: [
              CartItem(
                product: mockProducts[0],
                quantity: 1,
                selectedVariant: 'Golden Sand',
              ),
              CartItem(
                product: mockProducts[7],
                quantity: 1,
                selectedVariant: '250g Classic Jar',
              ),
            ],
            subtotal: 93.00,
            discount: 9.30,
            totalAmount: 83.70,
            orderDate: DateTime.now().subtract(const Duration(days: 4)),
            status: 'Delivered',
            shippingAddress: 'Flat 402, Rosewood Manor, Worli, Mumbai',
            paymentMethod: 'Google Pay (UPI)',
          )
        ]);

  CustomerOrder createOrder({
    required List<CartItem> items,
    required double subtotal,
    required double discount,
    required double totalAmount,
    required String address,
    required String paymentMethod,
  }) {
    final order = CustomerOrder(
      orderId: 'NIH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      items: List.from(items),
      subtotal: subtotal,
      discount: discount,
      totalAmount: totalAmount,
      orderDate: DateTime.now(),
      status: 'Processing',
      shippingAddress: address,
      paymentMethod: paymentMethod,
    );

    state = [order, ...state];
    return order;
  }
}

final ordersProvider = StateNotifierProvider<OrderNotifier, List<CustomerOrder>>((ref) {
  return OrderNotifier();
});
