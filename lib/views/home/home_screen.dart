import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../providers/product_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/service_card.dart';
import '../widgets/section_header.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategoryChip = 'All';

  final List<Map<String, dynamic>> _quickCategories = [
    {'name': 'All', 'icon': Icons.apps_rounded},
    {'name': 'Makeup', 'icon': Icons.brush_outlined},
    {'name': 'Jewellery', 'icon': Icons.diamond_outlined},
    {'name': 'Nails', 'icon': Icons.clean_hands_outlined},
    {'name': 'Candles', 'icon': Icons.light_mode_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    final bestsellers = ref.watch(bestsellerProductsProvider);
    final featured = ref.watch(featuredProductsProvider);
    final services = ref.watch(servicesProvider);
    final cartItemCount = ref.watch(cartProvider).itemCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top Custom Luxury App Bar
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'WELCOME TO',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: AppColors.secondary.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Nihara Luxury',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.search_rounded, size: 20, color: AppColors.textPrimary),
                          ),
                          onPressed: () {
                            ref.read(productFilterProvider.notifier).update((s) => s.copyWith(searchQuery: ''));
                            context.push('/products');
                          },
                        ),
                        Stack(
                          children: [
                            IconButton(
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: AppColors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.shopping_bag_outlined, size: 20, color: AppColors.textPrimary),
                              ),
                              onPressed: () => context.push('/cart'),
                            ),
                            if (cartItemCount > 0)
                              Positioned(
                                right: 6,
                                top: 6,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.secondary,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                                  child: Text(
                                    '$cartItemCount',
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Hero Banner
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFE8B2B5),
                        Color(0xFFB76E79),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.25),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Right Image
                      Positioned(
                        right: -10,
                        top: 0,
                        bottom: 0,
                        width: 170,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(24)),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return const LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                stops: [0.0, 0.4],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ).createShader(bounds);
                            },
                            blendMode: BlendMode.dstIn,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=600&q=80',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      // Text & CTA
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'NEW FESTIVE RELEASE',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Royal Rose Gold\nGlow Collection',
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                ref.read(productFilterProvider.notifier).update((s) => s.copyWith(category: 'All'));
                                context.push('/products');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.textPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Shop Now',
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward_rounded, size: 14),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Category Filter Chips
            SliverToBoxAdapter(
              child: SizedBox(
                height: 54,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: _quickCategories.length,
                  itemBuilder: (context, index) {
                    final cat = _quickCategories[index];
                    final isSelected = _selectedCategoryChip == cat['name'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        showCheckmark: false,
                        avatar: Icon(
                          cat['icon'] as IconData,
                          size: 16,
                          color: isSelected ? AppColors.white : AppColors.secondary,
                        ),
                        label: Text(cat['name'] as String),
                        labelStyle: TextStyle(
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        ),
                        backgroundColor: AppColors.white,
                        selectedColor: AppColors.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected ? AppColors.secondary : AppColors.border,
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategoryChip = cat['name'] as String;
                          });
                          ref.read(productFilterProvider.notifier).update((s) => s.copyWith(category: cat['name'] as String));
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Prominent Book Appointment Banner Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.6), width: 1),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: AppColors.roseLight,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.face_retouching_natural_rounded,
                          color: AppColors.secondary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'At-Home Bridal & Glam Services',
                              style: TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Book expert stylists for makeup, nails & spa.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => context.go('/book'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondary,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bestsellers Section Header
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Bestseller Beauties',
                subtitle: 'Most loved products by Nihara patrons',
                onActionTap: () {
                  ref.read(productFilterProvider.notifier).update((s) => s.copyWith(sortBy: 'popular', category: 'All'));
                  context.push('/products');
                },
              ),
            ),

            // Bestsellers Horizontal List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: bestsellers.length,
                  itemBuilder: (context, index) {
                    final item = bestsellers[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: ProductCard(product: item, width: 160),
                    );
                  },
                ),
              ),
            ),

            // Featured Collections Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: SectionHeader(
                  title: 'Featured Luxuries',
                  subtitle: 'Handpicked products for timeless elegance',
                  onActionTap: () {
                    ref.read(productFilterProvider.notifier).update((s) => s.copyWith(category: 'All'));
                    context.push('/products');
                  },
                ),
              ),
            ),

            // Featured Grid (2 columns)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = featured[index % featured.length];
                    return ProductCard(product: item, width: double.infinity);
                  },
                  childCount: featured.length,
                ),
              ),
            ),

            // Salon & Spa Experience Section Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SectionHeader(
                  title: 'Signature Salon Services',
                  subtitle: 'Experience royal treatment at salon or home',
                  onActionTap: () => context.go('/book'),
                ),
              ),
            ),

            // Services list (first 3)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final service = services[index];
                    return ServiceCard(service: service);
                  },
                  childCount: services.length > 3 ? 3 : services.length,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
