import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Skema warna sederhana untuk dashboard
    final primaryColor = const Color(0xFFD87C34); // Biru Modern
    final backgroundColor = const Color(0xFFFFF6E5); // Abu-abu sangat muda

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBodyBehindAppBar: true, // Agar body menyatu dengan status bar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Dashboard Admin',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: controller.logout,
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: Column(
        children: [
          // --- 1. HEADER BAGIAN ATAS ---
          _buildHeader(primaryColor),

          // --- 2. MENU GRID (Konten Utama) ---
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(20.0),
              crossAxisCount: 2, // Menampilkan 2 menu ke samping
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                // Menu 1: Kelola Produk
                _buildMenuCard(
                  title: 'Kelola Produk',
                  subtitle: 'Edit/Hapus Barang',
                  icon: Icons.inventory_2_rounded,
                  color: Colors.orangeAccent,
                  onTap: () => Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST),
                ),

                // Menu 2: Chat User
                _buildMenuCard(
                  title: 'Chat Pelanggan',
                  subtitle: 'Balas Pesan',
                  icon: Icons.chat_bubble_rounded,
                  color: Colors.greenAccent.shade700,
                  onTap: () => Get.toNamed(AppRoutes.ADMIN_CHAT_LIST),
                ),

                // (Opsional) Menu Placeholder: Laporan
                _buildMenuCard(
                  title: 'Laporan',
                  subtitle: 'Statistik Penjualan',
                  icon: Icons.bar_chart_rounded,
                  color: Colors.purpleAccent,
                  onTap: () {
                    Get.snackbar('Info', 'Fitur Laporan akan segera hadir!',
                        backgroundColor: Colors.white, margin: EdgeInsets.all(16));
                  },
                ),

                // (Opsional) Menu Placeholder: Pengaturan
                _buildMenuCard(
                  title: 'Pengaturan',
                  subtitle: 'Akun Admin',
                  icon: Icons.settings_rounded,
                  color: Colors.blueGrey,
                  onTap: () {
                     Get.snackbar('Info', 'Fitur Pengaturan akan segera hadir!',
                        backgroundColor: Colors.white, margin: EdgeInsets.all(16));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Terpisah untuk Header Gradient
  Widget _buildHeader(Color primaryColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 100, bottom: 30, left: 20, right: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor,
            primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Selamat Datang, Admin!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Apa yang ingin Anda kerjakan hari ini?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Widget Terpisah untuk Card Menu
  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Lingkaran Ikon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),
              const Spacer(),
              // Judul
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}