class Product {
  final String id;
  final String name;
  final String category; // Makeup, Jewellery, Nails, Candles
  final String subCategory;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> galleryImages;
  final String description;
  final List<String> details;
  final List<String> variants; // Colors / Shades / Scents / Metals
  final List<String>? sizes;
  final bool isBestseller;
  final bool isFeatured;
  final bool inStock;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.subCategory,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.galleryImages,
    required this.description,
    required this.details,
    required this.variants,
    this.sizes,
    this.isBestseller = false,
    this.isFeatured = false,
    this.inStock = true,
  });

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    return (((originalPrice! - price) / originalPrice!) * 100).round();
  }
}
