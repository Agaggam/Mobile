import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
// --- IMPORT BARU ---
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ThemeController themeController = Get.find();

    // --- LOGIKA BARU: AMBIL DATA USER DARI SUPABASE ---
    final SupabaseService supabase = Get.find<SupabaseService>();
    final user = supabase.currentUser;

    // Olah data user (fallback ke 'Tamu' jika null)
    final String email = user?.email ?? "Tamu";
    // Ambil username dari bagian depan email (sebelum @)
    final String username = email.contains('@') ? email.split('@')[0] : email;
    // Ambil inisial huruf pertama
    final String initial = email.isNotEmpty ? email[0].toUpperCase() : "T";
    // --------------------------------------------------

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Hero Section
          UserAccountsDrawerHeader(
            accountName: Text(
              username, // <-- Tampilkan Username Dinamis
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
            accountEmail: Text(
              email, // <-- Tampilkan Email Dinamis
              style: TextStyle(
                color: theme.colorScheme.onPrimary.withOpacity(0.8),
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: theme.colorScheme.onPrimary,
              child: Text(
                initial, // <-- Tampilkan Inisial Dinamis
                style: TextStyle(
                  fontSize: 40.0,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            decoration: BoxDecoration(color: theme.colorScheme.primary),
          ),

          // Pilihan Utama
          _buildDrawerItem(
            icon: Icons.shopping_cart_outlined,
            text: 'Cart',
            onTap: () {
              Get.back();
              Get.toNamed(AppRoutes.CART);
            },
          ),
          _buildDrawerItem(
            icon: Icons.favorite_border,
            text: 'Wishlist',
            onTap: () {
              Get.snackbar('Info', 'Fitur Wishlist segera hadir');
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'Order History',
            onTap: () {
              Get.snackbar('Info', 'Fitur Order History segera hadir');
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            text: 'News Info',
            onTap: () {
              Get.snackbar('Info', 'Fitur News segera hadir');
            },
          ),
          _buildDrawerItem(
            icon: Icons.notifications_none,
            text: 'Notification',
            onTap: () {
              Get.snackbar('Info', 'Fitur Notifikasi segera hadir');
            },
          ),

          Divider(thickness: 1, indent: 16, endIndent: 16),

          // Bagian Others
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Others',
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.hintColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildDrawerItem(
            icon: Icons.integration_instructions_outlined,
            text: 'Instruction',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Setting',
            onTap: () {},
          ),

          // Theme Toggle
          Obx(
            () => SwitchListTile(
              title: Text(
                themeController.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
              ),
              value: themeController.isDarkMode.value,
              onChanged: (value) {
                themeController.toggleTheme();
              },
              secondary: Icon(
                themeController.isDarkMode.value
                    ? Icons.dark_mode_outlined
                    : Icons.light_mode_outlined,
              ),
            ),
          ),

          // Logout
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: () async {
              // Logout via Supabase
              await supabase.client.auth.signOut();
              Get.offAllNamed(AppRoutes.LOGIN);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () {
        Get.back(); // Tutup drawer
        onTap();
      },
    );
  }
}
