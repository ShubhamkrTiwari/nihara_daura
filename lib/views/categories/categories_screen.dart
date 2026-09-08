import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/product_provider.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {
      'title': 'Makeup Services & Products',
      'category': 'Makeup',
      'itemCount': '14 Products',
      'imageUrl': 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
      'subcategories': ['Face Foundations', 'Lipsticks & Gloss', 'Eyeshadow Palettes', 'Blushes & Highlighters'],
    },
    {
      'title': 'Handcrafted Jewellery',
      'category': 'Jewellery',
      'itemCount': '18 Products',
      'imageUrl': 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
      'subcategories': ['Kundan Chandbalis', 'Rose Gold Chokers', 'Temple Bangles', 'Bridal Sets'],
    },
    {
      'title': 'Nail Extensions & Nail Art',
      'category': 'Nails',
      'itemCount': '12 Products',
      'imageUrl': 'https://images.unsplash.com/photo-1604654894610-df63bc536371?w=800&q=80',
      'subcategories': ['Press-On Kits', 'Gel Lacquer', 'Chrome Nail Art', 'Cuticle Elixirs'],
    },
    {
      'title': 'Candles & Home Fragrance',
      'category': 'Candles',
      'itemCount': '10 Products',
      'imageUrl': 'https://images.unsplash.com/photo-1603006905003-be475563bc59?w=800&q=80',
      'subcategories': ['Soy Wax Jar Candles', 'Reed Diffusers', 'Aroma Room Sprays', 'Wax Melts'],
    },
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              ref.read(productFilterProvider.notifier).update((s) => s.copyWith(searchQuery: ''));
              context.push('/products');
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return GestureDetector(
            onTap: () {
              ref.read(productFilterProvider.notifier).update(
                    (s) => s.copyWith(category: cat['category'] as String, subCategory: 'All'),
                  );
              context.push('/products');
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border, width: 0.8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Banner
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        child: SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: Image.network(
                            cat['imageUrl'] as String,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat['title'] as String,
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                              ),
                            ),
                            Text(
                              cat['itemCount'] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Subcategory Chips
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (cat['subcategories'] as List<String>).map((sub) {
                        return GestureDetector(
                          onTap: () {
                            ref.read(productFilterProvider.notifier).update(
                                  (s) => s.copyWith(
                                    category: cat['category'] as String,
                                    subCategory: sub,
                                  ),
                                );
                            context.push('/products');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              sub,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
