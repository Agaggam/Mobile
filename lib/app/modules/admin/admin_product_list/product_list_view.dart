import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_list_controller.dart';
import 'package:intl/intl.dart';

class AdminProductListView extends GetView<AdminProductListController> {
  const AdminProductListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA (Sesuai Referensi) ---
    final Color backgroundColor = const Color(0xFFFFF6E5); // Krem
    final Color primaryColor = const Color(0xFFD87C34);    // Oranye Bata
    final Color textDark = const Color(0xFF4E342E);        // Coklat Tua
    final Color cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: textDark),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Kelola Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textDark,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      
      // --- TOMBOL TAMBAH (+) ---
      floatingActionButton: FloatingActionButton(
        onPressed: controller.goToAddProduct,
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
        tooltip: 'Tambah Produk',
      ),

      body: Obx(() {
        // 1. Loading State
        if (controller.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        // 2. Empty State (Jika produk kosong)
        if (controller.productList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada produk',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        // 3. List Produk
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          physics: const BouncingScrollPhysics(), // Efek mantul saat scroll
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                // --- GAMBAR PRODUK ---
                leading: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback jika gambar error/link mati
                        return Icon(Icons.broken_image_rounded, color: Colors.grey[400]);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: SizedBox(
                            width: 20, height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              color: primaryColor.withOpacity(0.5)
                            )
                          )
                        );
                      },
                    ),
                  ),
                ),
                
                // --- JUDUL & HARGA ---
                title: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: textDark,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    NumberFormat.currency(
                      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0
                    ).format(product.price),
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // --- TOMBOL AKSI (EDIT & DELETE) ---
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Tombol Edit
                    _buildActionButton(
                      icon: Icons.edit_rounded,
                      color: Colors.blueAccent,
                      onTap: () => controller.goToEditProduct(product),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Hapus
                    _buildActionButton(
                      icon: Icons.delete_outline_rounded,
                      color: Colors.redAccent,
                      onTap: () {
                         _showDeleteConfirmDialog(context, product, primaryColor);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Helper Widget untuk Tombol Kecil (Edit/Hapus)
  Widget _buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icon, color: color, size: 22),
        ),
      ),
    );
  }

  // Helper untuk Menampilkan Dialog Konfirmasi Hapus yang Cantik
  void _showDeleteConfirmDialog(BuildContext context, dynamic product, Color primaryColor) {
    Get.defaultDialog(
      title: 'Hapus Produk',
      titleStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      middleText: 'Apakah Anda yakin ingin menghapus "${product.title}"?',
      middleTextStyle: GoogleFonts.poppins(color: Colors.grey[700]),
      backgroundColor: Colors.white,
      radius: 16,
      confirm: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () {
          Get.back(); // Tutup dialog
          controller.deleteProduct(product.id);
        },
        child: Text('Hapus', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      cancel: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey[400]!),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
        onPressed: () => Get.back(),
        child: Text('Batal', style: GoogleFonts.poppins(color: Colors.black87)),
      ),
    );
  }
}