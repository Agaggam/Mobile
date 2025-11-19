import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'product_form_controller.dart';
import 'dart:io'; // Perlu import ini untuk File Image

class AdminProductFormView extends GetView<AdminProductFormController> {
  const AdminProductFormView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- PALET WARNA ---
    final Color backgroundColor = const Color(0xFFFFF6E5); // Krem
    final Color primaryColor = const Color(0xFFD87C34); // Oranye Bata
    final Color textDark = const Color(0xFF4E342E); // Coklat Tua
    final Color inputFillColor = Colors.white;

    // Style umum untuk Input Field
    InputDecoration customInputDecoration(String label, {String? prefix}) {
      return InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixText: prefix,
        prefixStyle:
            GoogleFonts.poppins(color: textDark, fontWeight: FontWeight.bold),
        filled: true,
        fillColor: inputFillColor,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none, // Hilangkan garis border default
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
      );
    }

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
          controller.productToEdit == null ? 'Tambah Produk' : 'Edit Produk',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: textDark,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: primaryColor));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- BAGIAN GAMBAR ---
                Center(
                  child: GestureDetector(
                    onTap: controller.pickImage,
                    child: Stack(
                      children: [
                        // Container Gambar Utama
                        Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: _buildImagePreview(primaryColor),
                          ),
                        ),
                        // Ikon Kamera Kecil (Badge)
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(Icons.camera_alt,
                                color: Colors.white, size: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Upload Foto Produk',
                    style: GoogleFonts.poppins(
                        color: Colors.grey[600], fontSize: 12),
                  ),
                ),
                const SizedBox(height: 32),

                // --- NAMA PRODUK ---
                Text('Informasi Produk',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: textDark,
                        fontSize: 16)),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
                  child: TextFormField(
                    controller: controller.titleC,
                    style: GoogleFonts.poppins(color: textDark),
                    decoration: customInputDecoration('Nama Produk'),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama wajib diisi'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // --- HARGA ---
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
                  child: TextFormField(
                    controller: controller.priceC,
                    style: GoogleFonts.poppins(color: textDark),
                    decoration: customInputDecoration('Harga', prefix: 'Rp '),
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Harga wajib diisi'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),

                // --- KATEGORI DROPDOWN ---
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
                  child: DropdownButtonFormField<int>(
                    value: controller.selectedCategoryId.value,
                    style: GoogleFonts.poppins(color: textDark),
                    icon: Icon(Icons.keyboard_arrow_down_rounded,
                        color: primaryColor),
                    decoration: customInputDecoration('Pilih Kategori'),
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    items: controller.categories.map((cat) {
                      return DropdownMenuItem(
                        value: cat.id,
                        child: Text(cat.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedCategoryId.value = value;
                    },
                    validator: (value) {
                      if (controller.productToEdit == null && value == null) {
                        return 'Kategori wajib dipilih';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // --- DESKRIPSI ---
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4))
                  ]),
                  child: TextFormField(
                    controller: controller.descriptionC,
                    style: GoogleFonts.poppins(color: textDark),
                    decoration:
                        customInputDecoration('Deskripsi Produk').copyWith(
                      alignLabelWithHint:
                          true, // Agar label ada di pojok kiri atas textarea
                    ),
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Deskripsi wajib diisi'
                        : null,
                  ),
                ),
                const SizedBox(height: 40),

                // --- TOMBOL SIMPAN ---
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: controller.saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadowColor: primaryColor.withOpacity(0.4),
                    ),
                    child: Text(
                      'SIMPAN PRODUK',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  // Widget Preview Gambar yang lebih clean
  Widget _buildImagePreview(Color primaryColor) {
    if (controller.selectedImage.value != null) {
      // Jika user baru saja memilih gambar dari galeri (File)
      return Image.file(
        controller.selectedImage.value!,
        fit: BoxFit.cover,
      );
    } else if (controller.existingImageUrl.value.isNotEmpty) {
      // Jika sedang edit dan sudah ada gambar sebelumnya (Network)
      return Image.network(
        controller.existingImageUrl.value,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Center(
            child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40)),
      );
    } else {
      // Kosong
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_photo_alternate_outlined,
              size: 50, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text("Tambah Foto",
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[400]))
        ],
      );
    }
  }
}
