import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../widgets/nihara_app_bar.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Widget _buildAvatarWidget(String url, {double radius = 26}) {
    final effectiveUrl = url.trim();

    if (effectiveUrl.isEmpty) {
      return _buildDefaultAvatar(radius);
    }

    if (effectiveUrl.startsWith('data:image')) {
      try {
        final base64Str = effectiveUrl.split(',').last;
        final bytes = base64Decode(base64Str);
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.goldLight,
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildDefaultAvatar(radius),
            ),
          ),
        );
      } catch (_) {
        return _buildDefaultAvatar(radius);
      }
    }

    if (effectiveUrl.startsWith('http://') || effectiveUrl.startsWith('https://') || effectiveUrl.startsWith('blob:')) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.goldLight,
        child: ClipOval(
          child: Image.network(
            effectiveUrl,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildDefaultAvatar(radius),
          ),
        ),
      );
    }

    try {
      if (!kIsWeb && File(effectiveUrl).existsSync()) {
        final file = File(effectiveUrl);
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.goldLight,
          child: ClipOval(
            child: Image.file(
              file,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildDefaultAvatar(radius),
            ),
          ),
        );
      }
    } catch (_) {}

    return _buildDefaultAvatar(radius);
  }

  Widget _buildDefaultAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.goldLight,
      child: ClipOval(
        child: Image.network(
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.person_rounded, size: radius * 1.2, color: AppColors.secondary),
        ),
      ),
    );
  }

  void _showEditProfileBottomSheet(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProfileProvider);
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final customUrlController = TextEditingController();
    String selectedAvatar = user.avatarUrl.isNotEmpty ? user.avatarUrl : 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80';
    bool isSubmitting = false;
    final ImagePicker picker = ImagePicker();

    final avatarPresets = [
      'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=400&q=80',
      'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
      'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=400&q=80',
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400&q=80',
    ];

    showModalBottomSheet(
      context: context,
      useRootNavigator: true, // Opens above the bottom navigation bar shell
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            void showCustomUrlDialog() {
              customUrlController.text = selectedAvatar;
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  backgroundColor: AppColors.white,
                  title: const Text('Custom Image Link', style: TextStyle(fontWeight: FontWeight.bold)),
                  content: TextField(
                    controller: customUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Paste Image URL',
                      hintText: 'https://example.com/photo.jpg',
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogCtx),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary),
                      onPressed: () {
                        if (customUrlController.text.trim().isNotEmpty) {
                          setModalState(() {
                            selectedAvatar = customUrlController.text.trim();
                          });
                        }
                        Navigator.pop(dialogCtx);
                      },
                      child: const Text('Apply', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            Future<void> pickImageFromDevice(ImageSource source) async {
              try {
                final XFile? photo = await picker.pickImage(
                  source: source,
                  imageQuality: 85,
                  maxWidth: 800,
                );
                if (photo != null) {
                  final bytes = await photo.readAsBytes();
                  final base64Image = 'data:image/jpeg;base64,${base64Encode(bytes)}';
                  setModalState(() {
                    selectedAvatar = base64Image;
                  });
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Image photo loaded from device!'),
                        backgroundColor: AppColors.secondary,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                }
              } on MissingPluginException catch (_) {
                if (context.mounted) {
                  showCustomUrlDialog();
                }
              } catch (e) {
                if (context.mounted) {
                  showCustomUrlDialog();
                }
              }
            }

            void showDeviceImagePickerOptions() {
              showModalBottomSheet(
                context: context,
                useRootNavigator: true,
                backgroundColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (ctx) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Upload Profile Photo File',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 20),
                      ListTile(
                        leading: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                        title: const Text('Upload Photo File from Gallery'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await pickImageFromDevice(ImageSource.gallery);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.camera_alt_rounded, color: AppColors.secondary),
                        title: const Text('Take Photo with Camera'),
                        onTap: () async {
                          Navigator.pop(ctx);
                          await pickImageFromDevice(ImageSource.camera);
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.link_rounded, color: AppColors.secondary),
                        title: const Text('Enter Image URL Link'),
                        onTap: () {
                          Navigator.pop(ctx);
                          showCustomUrlDialog();
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 28,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Edit Profile',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),

                    // Prominent Selected Avatar Live Preview
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: AppColors.goldGradient,
                            ),
                            child: _buildAvatarWidget(selectedAvatar, radius: 42),
                          ),
                          GestureDetector(
                            onTap: () => pickImageFromDevice(ImageSource.gallery),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Avatar Selection & Direct Gallery Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Choose Avatar or Upload', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        GestureDetector(
                          onTap: showDeviceImagePickerOptions,
                          child: const Row(
                            children: [
                              Icon(Icons.more_horiz_rounded, size: 18, color: AppColors.secondary),
                              SizedBox(width: 4),
                              Text(
                                'More Options',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Direct Gallery Pick Button Box
                        GestureDetector(
                          onTap: () => pickImageFromDevice(ImageSource.gallery),
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.goldLight,
                              border: Border.all(
                                color: !avatarPresets.contains(selectedAvatar) ? AppColors.secondary : AppColors.border,
                                width: !avatarPresets.contains(selectedAvatar) ? 2.5 : 1.0,
                              ),
                            ),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_photo_alternate_rounded, size: 18, color: AppColors.secondary),
                                Text('Gallery', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                              ],
                            ),
                          ),
                        ),

                        // Preset Avatars
                        ...avatarPresets.map((url) {
                          final isSelected = selectedAvatar == url;
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                selectedAvatar = url;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? AppColors.secondary : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              padding: const EdgeInsets.all(2),
                              child: _buildAvatarWidget(url, radius: 22),
                            ),
                          );
                        }),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Full Name Field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person_outline_rounded, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Email Field
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email_outlined, color: AppColors.secondary),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Phone Field
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_outlined, color: AppColors.secondary),
                      ),
                    ),

                    const SizedBox(height: 24),

                    isSubmitting
                        ? const Center(
                            child: CircularProgressIndicator(color: AppColors.secondary),
                          )
                        : CustomButton(
                            text: 'Save Changes',
                            width: double.infinity,
                            onPressed: () async {
                              if (nameController.text.trim().isEmpty || emailController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Name and Email cannot be empty')),
                                );
                                return;
                              }

                              setModalState(() {
                                isSubmitting = true;
                              });

                              await ref.read(userProfileProvider.notifier).updateProfileWithFileApi(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    avatarFilePathOrUrl: selectedAvatar,
                                  );

                              if (context.mounted) {
                                Navigator.pop(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile Photo & Details Updated Successfully!'),
                                    backgroundColor: AppColors.secondary,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);

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
                      ),
                      child: ClipOval(
                        child: _buildAvatarWidget(user.avatarUrl, radius: 32),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (user.email.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                          if (user.phone.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(
                              user.phone,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: AppColors.secondary),
                      onPressed: () => _showEditProfileBottomSheet(context, ref),
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
                        ref.read(authProvider.notifier).logout();
                        context.go('/login');
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
