class BeautyService {
  final String id;
  final String title;
  final String category; // Makeup, Nails, Jewellery Styling
  final String duration; // e.g. "90 Mins"
  final double price;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final List<String> includes;
  final List<Artist> availableArtists;

  const BeautyService({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    required this.includes,
    required this.availableArtists,
  });
}

class Artist {
  final String id;
  final String name;
  final String role;
  final double rating;
  final String imageUrl;

  const Artist({
    required this.id,
    required this.name,
    required this.role,
    required this.rating,
    required this.imageUrl,
  });
}
