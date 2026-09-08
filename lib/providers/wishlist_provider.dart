import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'product_provider.dart';

class WishlistNotifier extends StateNotifier<Set<String>> {
  WishlistNotifier() : super({'p1', 'p4', 'p8'}); // Pre-populate a couple for realistic feel

  void toggleFavorite(String productId) {
    if (state.contains(productId)) {
      state = {...state}..remove(productId);
    } else {
      state = {...state, productId};
    }
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, Set<String>>((ref) {
  return WishlistNotifier();
});

final wishlistProductsProvider = Provider<List<Product>>((ref) {
  final ids = ref.watch(wishlistProvider);
  final allProducts = ref.watch(productsProvider);
  return allProducts.where((p) => ids.contains(p.id)).toList();
});
