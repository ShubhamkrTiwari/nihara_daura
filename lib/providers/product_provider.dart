import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';

final mockProducts = <Product>[
  // MAKEUP
  const Product(
    id: 'p1',
    name: 'Glow Velvet Silk Foundation',
    category: 'Makeup',
    subCategory: 'Face',
    price: 2499.00,
    originalPrice: 2999.00,
    rating: 4.9,
    reviewCount: 142,
    imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=800&q=80',
      'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80',
    ],
    description: 'A weightless, hydrating silk foundation crafted for Indian skintones. Delivers a soft-focus radiant glow with 16-hour breathable coverage.',
    details: [
      'Medium to buildable full coverage',
      'Infused with Hyaluronic Acid & Rose Water',
      'Non-comedogenic & transfer-resistant',
      'Dermatologically tested'
    ],
    variants: ['Warm Ivory', 'Golden Sand', 'Rich Almond', 'Deep Honey'],
    sizes: ['30 ml'],
    isBestseller: true,
    isFeatured: true,
  ),
  const Product(
    id: 'p2',
    name: 'Royal Rosewood Satin Lipstick',
    category: 'Makeup',
    subCategory: 'Lips',
    price: 1499.00,
    originalPrice: 1799.00,
    rating: 4.8,
    reviewCount: 98,
    imageUrl: 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=800&q=80',
      'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80',
    ],
    description: 'Enriched with Shea butter and Jojoba oil, this rich rosewood lipstick glides like butter and leaves an enchanting satin finish.',
    details: [
      'Long-lasting 12-hour comfortable wear',
      'Enriched with Vitamin E and Jojoba',
      'Cruelty-free & Vegan'
    ],
    variants: ['Rosewood', 'Gulabi Nude', 'Royal Crimson', 'Berry Bloom'],
    isBestseller: true,
    isFeatured: false,
  ),
  const Product(
    id: 'p3',
    name: 'Celestial Shimmer Eyeshadow Palette',
    category: 'Makeup',
    subCategory: 'Eyes',
    price: 3499.00,
    originalPrice: 3999.00,
    rating: 4.9,
    reviewCount: 210,
    imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=800&q=80',
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
    ],
    description: '12 high-pigment shades inspired by Indian royal palaces — featuring rich bronzes, rose gold foil shimmers, and velvety mattes.',
    details: [
      '12 buttery smooth blendable shades',
      'Mirror included inside luxurious compact',
      'Smudge-proof formula'
    ],
    variants: ['Royal Palace Edition'],
    isBestseller: false,
    isFeatured: true,
  ),

  // JEWELLERY
  const Product(
    id: 'p4',
    name: 'Chandbali Emerald & Pearl Earrings',
    category: 'Jewellery',
    subCategory: 'Earrings',
    price: 8500.00,
    originalPrice: 9999.00,
    rating: 5.0,
    reviewCount: 76,
    imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
      'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
    ],
    description: 'Handcrafted Kundan Chandbali earrings embellished with natural emerald droplets and freshwater pearls, finished in 18k Rose Gold polish.',
    details: [
      'Material: Brass with 18k Rose Gold Plating',
      'Stone: Cubic Zirconia & Faux Emerald',
      'Weight: 28 grams pair',
      'Includes signature velvet Nihara keepsake box'
    ],
    variants: ['Rose Gold & Emerald', 'Yellow Gold & Ruby'],
    isBestseller: true,
    isFeatured: true,
  ),
  const Product(
    id: 'p5',
    name: 'Nihara Signature Rose Gold Choker',
    category: 'Jewellery',
    subCategory: 'Necklaces',
    price: 12500.00,
    originalPrice: 14999.00,
    rating: 4.9,
    reviewCount: 54,
    imageUrl: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
    ],
    description: 'A timeless statement necklace featuring delicate filigree work, hand-set micro pearls, and subtle gold undertones suitable for festive and bridal wear.',
    details: [
      'Adjustable silk dori closure',
      'Anti-tarnish protective coating',
      'Handcrafted by master artisans in Jaipur'
    ],
    variants: ['Rose Gold', 'Champagne Gold'],
    isBestseller: false,
    isFeatured: true,
  ),

  // NAILS
  const Product(
    id: 'p6',
    name: 'Rose Quartz Luxury Press-On Nails Set',
    category: 'Nails',
    subCategory: 'Press-On Nails',
    price: 1850.00,
    originalPrice: 2200.00,
    rating: 4.7,
    reviewCount: 188,
    imageUrl: 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800&q=80',
      'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800&q=80',
    ],
    description: 'Reusable salon-quality press-on nail kit with real gold foil foil accents, soft marble quartz finish, and extra strength nail gel adhesive.',
    details: [
      'Kit includes 24 nails in 12 sizes',
      'Includes adhesive tabs, nail glue, buffer & cuticle stick',
      'Lasts up to 2 weeks per application'
    ],
    variants: ['Almond Shape', 'Coffin Shape', 'Short Oval'],
    sizes: ['S', 'M', 'L'],
    isBestseller: true,
    isFeatured: false,
  ),
  const Product(
    id: 'p7',
    name: 'Nihara Velvet Gel Shine Nail Lacquer',
    category: 'Nails',
    subCategory: 'Nail Polish',
    price: 899.00,
    rating: 4.6,
    reviewCount: 62,
    imageUrl: 'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1632345031435-8727f6897d53?w=800&q=80',
    ],
    description: 'High-shine gel effect nail lacquer without needing UV light. Chip-resistant formula infused with Keratin and Argan oil.',
    details: [
      'Fast-drying formula (under 60s)',
      '10-Free non-toxic formula',
      'Wide flat brush for seamless 1-stroke application'
    ],
    variants: ['Rose Nude', 'Gold Dust', 'Blush Bloom', 'Crimson Passion'],
    isBestseller: false,
    isFeatured: false,
  ),

  // CANDLES & HOME FRAGRANCE
  const Product(
    id: 'p8',
    name: 'Jasmine & Amber Soy Wax Candle',
    category: 'Candles',
    subCategory: 'Soy Candles',
    price: 1999.00,
    originalPrice: 2499.00,
    rating: 4.9,
    reviewCount: 175,
    imageUrl: 'https://images.unsplash.com/photo-1603006905003-be475563bc59?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1603006905003-be475563bc59?w=800&q=80',
      'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&q=80',
    ],
    description: 'Hand-poured 100% natural soy wax candle with notes of royal Mogra Jasmine, warm Amber, and subtle Sandalwood. Poured into a matte rose gold ceramic jar.',
    details: [
      'Burn time: 55+ Hours',
      'Cotton double wick for clean burn',
      'Infused with 100% essential oils',
      'Reusable matte rose gold ceramic vessel'
    ],
    variants: ['250g Classic Jar', '400g Grand Jar'],
    isBestseller: true,
    isFeatured: true,
  ),
  const Product(
    id: 'p9',
    name: 'Oud & Rose Luxurious Room Diffuser',
    category: 'Candles',
    subCategory: 'Diffusers',
    price: 2799.00,
    rating: 4.8,
    reviewCount: 89,
    imageUrl: 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&q=80',
    galleryImages: [
      'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800&q=80',
    ],
    description: 'Transform your home into a serene sanctuary with natural rattan reeds and concentrated essential oils of Damascus Rose and rich Arabian Oud.',
    details: [
      'Diffuses aroma consistently for up to 90 days',
      'Includes 8 natural rattan reed sticks',
      'Alcohol-free formulation'
    ],
    variants: ['Oud & Rose', 'Cardamom & Vanilla'],
    isBestseller: false,
    isFeatured: false,
  ),
];

class ProductFilter {
  final String? category;
  final String? subCategory;
  final String searchQuery;
  final double minPrice;
  final double maxPrice;
  final double minRating;
  final String sortBy; // 'popular', 'price_low', 'price_high', 'rating'

  const ProductFilter({
    this.category,
    this.subCategory,
    this.searchQuery = '',
    this.minPrice = 0,
    this.maxPrice = 20000,
    this.minRating = 0,
    this.sortBy = 'popular',
  });

  ProductFilter copyWith({
    String? category,
    String? subCategory,
    String? searchQuery,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    String? sortBy,
  }) {
    return ProductFilter(
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

final productsProvider = Provider<List<Product>>((ref) {
  return mockProducts;
});

final productFilterProvider = StateProvider<ProductFilter>((ref) {
  return const ProductFilter();
});

final filteredProductsProvider = Provider<List<Product>>((ref) {
  final products = ref.watch(productsProvider);
  final filter = ref.watch(productFilterProvider);

  return products.where((p) {
    if (filter.category != null && filter.category != 'All') {
      if (p.category.toLowerCase() != filter.category!.toLowerCase()) {
        return false;
      }
    }
    if (filter.subCategory != null && filter.subCategory != 'All') {
      if (p.subCategory.toLowerCase() != filter.subCategory!.toLowerCase()) {
        return false;
      }
    }
    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      final nameMatch = p.name.toLowerCase().contains(q);
      final descMatch = p.description.toLowerCase().contains(q);
      final catMatch = p.category.toLowerCase().contains(q);
      if (!nameMatch && !descMatch && !catMatch) return false;
    }
    if (p.price < filter.minPrice || p.price > filter.maxPrice) {
      return false;
    }
    if (p.rating < filter.minRating) {
      return false;
    }
    return true;
  }).toList()
    ..sort((a, b) {
      switch (filter.sortBy) {
        case 'price_low':
          return a.price.compareTo(b.price);
        case 'price_high':
          return b.price.compareTo(a.price);
        case 'rating':
          return b.rating.compareTo(a.rating);
        case 'popular':
        default:
          return b.reviewCount.compareTo(a.reviewCount);
      }
    });
});

final bestsellerProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).where((p) => p.isBestseller).toList();
});

final featuredProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).where((p) => p.isFeatured).toList();
});

final productDetailProvider = Provider.family<Product?, String>((ref, id) {
  final products = ref.watch(productsProvider);
  try {
    return products.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
});
