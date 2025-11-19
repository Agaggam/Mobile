import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

class AccountController extends GetxController {
  // Ambil theme controller yang sudah ada
  final ThemeController themeController = Get.find();

  // --- AMBIL SupabaseService ---
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // --- DATA USER (OBSERVABLE / REAKTIF) ---
  // Kita ubah dari "get" biasa menjadi ".obs" agar UI bisa update otomatis
  var email = ''.obs;
  var username = 'User'.obs; // Ini akan diisi full_name
  var initial = 'U'.obs; // Ini untuk inisial avatar huruf
  var avatarUrl = ''.obs;

  // Observable untuk statistics (Dummy)
  var totalOrders = 12.obs;
  var totalReviews = 8.obs;
  var totalWishlist = 3.obs;
  var isVerified = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // --- LOAD DATA DARI SUPABASE ---
  void loadUserData() async {
    try {
      final user = _supabase.currentUser;
      if (user == null) return;

      // 1. Set Email dari Auth
      email.value = user.email ?? "Guest";

      // 2. Ambil Data Profil dari Database
      final response = await _supabase.client
          .from('profiles')
          .select('full_name, avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        // Update Username (Full Name)
        String dbName = response['full_name'] ?? '';

        // Jika nama di DB kosong, pakai nama dari potongan email
        if (dbName.isEmpty && email.value.contains('@')) {
          username.value = email.value.split('@')[0];
        } else {
          username.value = dbName;
        }

        // Update Avatar URL
        avatarUrl.value = response['avatar_url'] ?? '';

        // Update Inisial (Huruf Depan)
        if (username.value.isNotEmpty) {
          initial.value = username.value[0].toUpperCase();
        } else {
          initial.value = "U";
        }
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  // --- NAVIGASI ---
  void goToEditProfile() async {
    // Kita pakai await agar saat kembali dari halaman edit, data direfresh
    await Get.toNamed(AppRoutes.EDIT_PROFILE);
    loadUserData();
  }

  void goToOrderHistory() {
    Get.toNamed(AppRoutes.ORDER_HISTORY);
  }

  void goToShippingAddress() {
    Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
  }

  void goToNotificationSettings() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  void goToHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  void goToPrivacyPolicy() {
    Get.toNamed(AppRoutes.PRIVACY_POLICY);
  }

  void showAboutApp() {
    Get.snackbar(
      'Tentang Aplikasi',
      '89secondStuff v1.0.0\nA stylish shopping experience',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  void logout() {
    Get.defaultDialog(
      title: 'Konfirmasi Logout',
      content: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Apakah Anda yakin ingin keluar dari akun ini?',
          textAlign: TextAlign.center,
        ),
      ),
      textConfirm: 'Ya, Keluar',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        Get.back(); // Tutup dialog
        try {
          await _supabase.client.auth.signOut();
          Get.offAllNamed(AppRoutes.LOGIN);
          Get.snackbar(
            'Logout',
            'Anda telah keluar dari akun.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } catch (e) {
          Get.snackbar(
            'Error',
            'Gagal logout: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      },
      onCancel: () {},
    );
  }

  void updateStatistics({int? orders, int? reviews, int? wishlist}) {
    if (orders != null) totalOrders.value = orders;
    if (reviews != null) totalReviews.value = reviews;
    if (wishlist != null) totalWishlist.value = wishlist;
  }

  void refreshUserData() {
    loadUserData();
  }
}
