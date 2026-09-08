import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/nihara_app_bar.dart';

class ProductListScreen extends ConsumerStatefulWidget {
  const ProductListScreen({super.key});

  @override
  ConsumerState<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends ConsumerState<ProductListScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(productFilterProvider).searchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filter = ref.watch(productFilterProvider);
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Products',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          ref.read(productFilterProvider.notifier).update(
                                (s) => const ProductFilter(),
                              );
                          Navigator.pop(context);
                        },
                        child: const Text('Reset All', style: TextStyle(color: AppColors.secondary)),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),

                  // Category Selector
                  const Text('Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['All', 'Makeup', 'Jewellery', 'Nails', 'Candles'].map((cat) {
                      final isSelected = (filter.category ?? 'All') == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        selectedColor: AppColors.secondary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                        ),
                        onSelected: (selected) {
                          ref.read(productFilterProvider.notifier).update(
                                (s) => s.copyWith(category: cat),
                              );
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Price Range
                  Text(
                    'Max Price: \$${filter.maxPrice.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Slider(
                    value: filter.maxPrice,
                    min: 10,
                    max: 500,
                    divisions: 49,
                    activeColor: AppColors.secondary,
                    inactiveColor: AppColors.border,
                    label: '\$${filter.maxPrice.toInt()}',
                    onChanged: (val) {
                      ref.read(productFilterProvider.notifier).update(
                            (s) => s.copyWith(maxPrice: val),
                          );
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 16),

                  // Rating Filter
                  const Text('Minimum Rating', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [0.0, 4.0, 4.5, 4.8].map((r) {
                      final isSelected = filter.minRating == r;
                      return ChoiceChip(
                        label: Text(r == 0.0 ? 'Any' : '$r★ & above'),
                        selected: isSelected,
                        selectedColor: AppColors.secondary,
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                        ),
                        onSelected: (selected) {
                          ref.read(productFilterProvider.notifier).update(
                                (s) => s.copyWith(minRating: r),
                              );
                          setModalState(() {});
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        final currentSort = ref.watch(productFilterProvider).sortBy;
        final options = [
          {'id': 'popular', 'title': 'Popularity'},
          {'id': 'price_low', 'title': 'Price: Low to High'},
          {'id': 'price_high', 'title': 'Price: High to Low'},
          {'id': 'rating', 'title': 'Top Rated'},
        ];

        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sort Products',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(),
              ...options.map((opt) {
                final isSelected = currentSort == opt['id'];
                return ListTile(
                  title: Text(opt['title']!),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.secondary)
                      : null,
                  onTap: () {
                    ref.read(productFilterProvider.notifier).update(
                          (s) => s.copyWith(sortBy: opt['id']),
                        );
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(filteredProductsProvider);
    final filter = ref.watch(productFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: NiharaAppBar(
        title: filter.category == null || filter.category == 'All'
            ? 'All Products'
            : filter.category!,
        showBackButton: true,
      ),
      body: Column(
        children: [
          // Search & Filter Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search products, lipstick, candles...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                ref.read(productFilterProvider.notifier).update((s) => s.copyWith(searchQuery: ''));
                              },
                            )
                          : null,
                    ),
                    onChanged: (val) {
                      ref.read(productFilterProvider.notifier).update((s) => s.copyWith(searchQuery: val));
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.secondary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _showFilterBottomSheet,
                ),
                IconButton.filledTonal(
                  icon: const Icon(Icons.swap_vert_rounded, color: AppColors.secondary),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.white,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: _showSortBottomSheet,
                ),
              ],
            ),
          ),

          // Active Filters Row
          if ((filter.category != null && filter.category != 'All') || filter.searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  const Text('Active:', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(width: 6),
                  if (filter.category != null && filter.category != 'All')
                    Chip(
                      label: Text(filter.category!),
                      onDeleted: () => ref.read(productFilterProvider.notifier).update((s) => s.copyWith(category: 'All')),
                      deleteIcon: const Icon(Icons.cancel, size: 14),
                    ),
                ],
              ),
            ),

          // Products Count Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${products.length} Items Found',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Grid View
          Expanded(
            child: products.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off_rounded, size: 64, color: AppColors.border),
                        const SizedBox(height: 12),
                        const Text(
                          'No products found',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Try adjusting your search or filters.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            _searchController.clear();
                            ref.read(productFilterProvider.notifier).update((s) => const ProductFilter());
                          },
                          child: const Text('Reset Filters'),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.65,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index], width: double.infinity);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
