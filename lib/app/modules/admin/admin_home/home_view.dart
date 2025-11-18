import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart'; // <-- IMPORT BARU
import 'home_controller.dart';

class AdminHomeView extends GetView<AdminHomeController> {
  const AdminHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.logout,
          ),
        ],
      ),
      // --- PERBARUI BODY ---
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tombol CRUD Produk (dummy, untuk nanti)
          Card(
            child: ListTile(
              leading: const Icon(Icons.edit_document),
              title: const Text('Kelola Produk'),
              subtitle: const Text('Tambah, edit, atau hapus produk'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Get.toNamed(AppRoutes.ADMIN_PRODUCT_LIST);
              },
            ),
          ),
          // Tombol Daftar Chat
          Card(
            child: ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Chat User'),
              subtitle: const Text('Balas pesan dari pelanggan'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigasi ke halaman daftar chat
                Get.toNamed(AppRoutes.ADMIN_CHAT_LIST);
              },
            ),
          ),
        ],
      ),
      // --- AKHIR PERBARUAN ---
    );
  }
}
