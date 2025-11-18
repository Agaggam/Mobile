import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';

class AccountController extends GetxController {
  // Ambil theme controller yang sudah ada
  final ThemeController themeController = Get.find();

  // --- TAMBAHAN: Ambil SupabaseService ---
  final SupabaseService _supabase = Get.find<SupabaseService>();
  // ----------------

  // Data user (Dinamis dari Supabase)
  // Kita gunakan getter agar selalu mengambil data terbaru dari currentUser
  String get email => _supabase.currentUser?.email ?? "Guest";

  // Username diambil dari bagian depan email (sebagai fallback sederhana)
  String get username => email.contains('@') ? email.split('@')[0] : "User";

  // Inisial diambil dari huruf pertama email
  String get initial => email.isNotEmpty ? email[0].toUpperCase() : "G";

  // Observable untuk statistics (Masih dummy untuk saat ini)
  var totalOrders = 12.obs;
  var totalReviews = 8.obs;
  var totalWishlist = 3.obs;

  // Observable untuk user profile
  var isVerified = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  // Load user data dari API (jika diperlukan)
  void loadUserData() {
    // Di masa depan, Anda bisa mengambil data profil lengkap dari tabel 'profiles' di sini
  }

  // Navigasi ke Edit Profile
  void goToEditProfile() {
    Get.toNamed(AppRoutes.EDIT_PROFILE);
  }

  // Navigasi ke Order History
  void goToOrderHistory() {
    Get.toNamed(AppRoutes.ORDER_HISTORY);
  }

  // Navigasi ke Alamat Pengiriman
  void goToShippingAddress() {
    Get.toNamed(AppRoutes.SHIPPING_ADDRESS);
  }

  // Navigasi ke Notifikasi Settings
  void goToNotificationSettings() {
    Get.toNamed(AppRoutes.NOTIFICATION_SETTINGS);
  }

  // Navigasi ke Help Center
  void goToHelpCenter() {
    Get.toNamed(AppRoutes.HELP_CENTER);
  }

  // Navigasi ke Privacy Policy
  void goToPrivacyPolicy() {
    Get.toNamed(AppRoutes.PRIVACY_POLICY);
  }

  // Show About App
  void showAboutApp() {
    Get.snackbar(
      'Tentang Aplikasi',
      '89secondStuff v1.0.0\nA stylish shopping experience\n\nBuat Anda yang mencari gaya unik dan produk berkualitas.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  // --- FUNGSI LOGOUT YANG DIPERBARUI ---
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
      textConfirm: 'Ya, Keluar', // Teks tombol konfirmasi
      textCancel: 'Batal', // Teks tombol batal
      confirmTextColor: Colors.white, // Warna teks tombol konfirmasi
      onConfirm: () async {
        // Tutup dialog terlebih dahulu
        Get.back();

        try {
          // 1. Sign out dari Supabase (hapus sesi server & lokal)
          await _supabase.client.auth.signOut();

          // 2. Hapus semua route dan kembali ke login
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
      onCancel: () {
        // Tidak perlu melakukan apa-apa, dialog otomatis tertutup
      },
    );
  }
  // --- AKHIR PERBAIKAN ---

  // Update statistics (untuk test/demo)
  void updateStatistics({
    int? orders,
    int? reviews,
    int? wishlist,
  }) {
    if (orders != null) totalOrders.value = orders;
    if (reviews != null) totalReviews.value = reviews;
    if (wishlist != null) totalWishlist.value = wishlist;
  }

  // Refresh user data
  void refreshUserData() {
    Get.snackbar(
      'Loading',
      'Memperbarui data...',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
    loadUserData();
  }
}
