import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../widgets/nihara_app_bar.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const NiharaAppBar(
        title: 'My Profile',
        showBackButton: false,
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.bgGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
          child: Column(
            children: [
              // User Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.secondary, width: 2),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ananya Roy',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'ananya.roy@example.com',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.workspace_premium_rounded, size: 14, color: AppColors.secondary),
                              SizedBox(width: 4),
                              Text(
                                'Nihara Royal Gold Member',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.secondary),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Profile Options Menu
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildOptionTile(
                      context,
                      icon: Icons.shopping_bag_outlined,
                      title: 'My Orders',
                      subtitle: 'Track past purchases and active orders',
                      onTap: () => context.push('/my-orders'),
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.calendar_month_outlined,
                      title: 'My Bookings',
                      subtitle: 'View upcoming salon & at-home appointments',
                      onTap: () => context.push('/my-bookings'),
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.location_on_outlined,
                      title: 'Saved Addresses',
                      subtitle: 'Manage home & office delivery addresses',
                      onTap: () => context.push('/addresses'),
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.favorite_border_rounded,
                      title: 'My Wishlist',
                      subtitle: 'Saved items & beauty favorites',
                      onTap: () => context.go('/wishlist'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildOptionTile(
                      context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Concierge Support',
                      subtitle: '24/7 dedicated beauty advisor',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Settings',
                      subtitle: 'Notifications, currency & privacy',
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    _buildOptionTile(
                      context,
                      icon: Icons.logout_rounded,
                      title: 'Log Out',
                      subtitle: 'Sign out from your Nihara account',
                      isDestructive: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Logged out successfully')),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.shade50 : AppColors.cardBg,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isDestructive ? Colors.redAccent : AppColors.secondary,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
    );
  }
}
