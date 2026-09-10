import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = const [
    OnboardingData(
      title: 'Flawless Beauty & Bridal Glamour',
      subtitle: 'Discover lightweight silk foundations, satin lipsticks, and bespoke makeup services designed for your royal glow.',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=800&q=80',
      badge: 'MAKEUP & COSMETICS',
    ),
    OnboardingData(
      title: 'Handcrafted Gold Jewellery & Nail Art',
      subtitle: 'Elevate your style with 18k Rose Gold Kundan earrings and salon-quality press-on nails with real gold leaf accents.',
      imageUrl: 'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=800&q=80',
      badge: 'JEWELLERY & NAILS',
    ),
    OnboardingData(
      title: 'Aromatic Ambiance & Home Fragrances',
      subtitle: 'Immerse in soy wax candles with Royal Mogra Jasmine notes or book expert beauty artists directly for salon services.',
      imageUrl: 'https://images.unsplash.com/photo-1603006905003-be475563bc59?w=800&q=80',
      badge: 'CANDLES & SALON SERVICES',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'N',
                            style: TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'NIHARA',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 16,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  if (_currentPage < _pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image Container with Soft Shadow and Rounded Borders
                        Container(
                          height: MediaQuery.of(context).size.height * 0.38,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.secondary.withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: Image.network(
                              data.imageUrl,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.goldLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.6)),
                          ),
                          child: Text(
                            data.badge,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondary,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title
                        Text(
                          data.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        Text(
                          data.subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentPage == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.secondary : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button
                  CustomButton(
                    text: _currentPage == _pages.length - 1 ? 'Explore Nihara' : 'Continue',
                    width: double.infinity,
                    onPressed: _onNext,
                    icon: _currentPage == _pages.length - 1
                        ? Icons.auto_awesome_rounded
                        : Icons.arrow_forward_rounded,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String badge;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.badge,
  });
}
