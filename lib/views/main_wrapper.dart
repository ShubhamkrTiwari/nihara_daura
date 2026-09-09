import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/wishlist_provider.dart';

class MainWrapper extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainWrapper({
    super.key,
    required this.navigationShell,
  });

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistCount = ref.watch(wishlistProvider).length;
    final currentIndex = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          height: 68,
          decoration: BoxDecoration(
            color: AppColors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: AppColors.secondary.withValues(alpha: 0.18),
                blurRadius: 20,
                offset: const Offset(0, 6),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Tab 0: Home
              _buildNavItem(
                index: 0,
                currentIndex: currentIndex,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
              ),

              // Tab 1: Categories
              _buildNavItem(
                index: 1,
                currentIndex: currentIndex,
                icon: Icons.grid_view_outlined,
                activeIcon: Icons.grid_view_rounded,
                label: 'Categories',
              ),

              // Tab 2: Book Service (Center Golden CTA Button)
              GestureDetector(
                onTap: () => _onTap(2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: currentIndex == 2
                        ? AppColors.goldGradient
                        : AppColors.softGoldGradient,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary,
                      width: currentIndex == 2 ? 1.5 : 0.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: currentIndex == 2 ? 0.35 : 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        currentIndex == 2 ? Icons.calendar_month_rounded : Icons.calendar_month_outlined,
                        size: 20,
                        color: currentIndex == 2 ? AppColors.white : AppColors.secondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Book',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: currentIndex == 2 ? AppColors.white : AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tab 3: Wishlist
              _buildNavItem(
                index: 3,
                currentIndex: currentIndex,
                icon: Icons.favorite_border_rounded,
                activeIcon: Icons.favorite_rounded,
                label: 'Wishlist',
                badgeCount: wishlistCount,
              ),

              // Tab 4: Profile
              _buildNavItem(
                index: 4,
                currentIndex: currentIndex,
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required int currentIndex,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
  }) {
    final isSelected = index == currentIndex;

    return GestureDetector(
      onTap: () => _onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: isSelected
            ? BoxDecoration(
                color: AppColors.goldLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border.withValues(alpha: 0.8)),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 20,
                  color: isSelected ? AppColors.secondary : AppColors.textSecondary,
                ),
                if (badgeCount > 0)
                  Positioned(
                    right: -8,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        gradient: AppColors.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? AppColors.secondary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
