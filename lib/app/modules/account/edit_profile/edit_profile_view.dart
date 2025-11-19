import 'dart:io'; // Wajib untuk FileImage
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        elevation: 1,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // BAGIAN FOTO
            _buildAvatarSection(theme, colorScheme),
            const SizedBox(height: 40),

            // BAGIAN INPUT
            _buildTextField(colorScheme, 'Nama Lengkap', 'Nama Anda',
                Icons.person_outline, controller.fullNameController),
            const SizedBox(height: 20),

            _buildTextField(colorScheme, 'Email', 'Email Anda',
                Icons.email_outlined, controller.emailController,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 20),

            _buildTextField(colorScheme, 'Nomor Telepon', '08xx...',
                Icons.phone_outlined, controller.phoneController,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 40),

            // TOMBOL SIMPAN
            Obx(() => SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: controller.isLoading.value
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2))
                        : Text('SIMPAN PERUBAHAN',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection(ThemeData theme, ColorScheme colorScheme) {
    return Column(
      children: [
        Stack(
          children: [
            Obx(() {
              // Logika Tampilan Gambar
              ImageProvider? imageProvider;
              if (controller.selectedImage.value != null) {
                // 1. Gambar Lokal (Baru dipilih)
                imageProvider = FileImage(controller.selectedImage.value!);
              } else if (controller.avatarUrl.value.isNotEmpty) {
                // 2. Gambar Database (URL)
                imageProvider = NetworkImage(controller.avatarUrl.value);
              }

              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withOpacity(0.1),
                  border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2), width: 2),
                  image: imageProvider != null
                      ? DecorationImage(image: imageProvider, fit: BoxFit.cover)
                      : null,
                ),
                // Jika tidak ada gambar, tampilkan Icon
                child: imageProvider == null
                    ? Icon(Icons.person, size: 60, color: colorScheme.primary)
                    : null,
              );
            }),

            // Loading saat upload
            Obx(() {
              if (controller.isUploadingImage.value) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child: const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Tombol Kamera
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('Tap kamera untuk ganti foto',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildTextField(ColorScheme colorScheme, String label, String hint,
      IconData icon, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: colorScheme.primary.withOpacity(0.7)),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
