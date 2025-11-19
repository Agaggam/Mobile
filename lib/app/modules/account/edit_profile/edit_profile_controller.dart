import 'dart:io'; // PENTING: Untuk File di HP
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/modules/account/account_controller.dart';

class EditProfileController extends GetxController {
  final SupabaseService _supabase = Get.find<SupabaseService>();

  // Controller Text Field
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  // Variables
  var isLoading = false.obs;
  var isUploadingImage = false.obs;
  var avatarUrl = ''.obs; // URL dari Database
  var selectedImage = Rx<File?>(null); // File lokal dari Galeri HP

  @override
  void onInit() {
    super.onInit();
    _initializeControllers();
    _loadUserProfile();
  }

  void _initializeControllers() {
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  // --- 1. LOAD DATA ---
  Future<void> _loadUserProfile() async {
    try {
      isLoading.value = true;
      final user = _supabase.currentUser;
      if (user == null) return;

      final response = await _supabase.client
          .from('profiles')
          .select('full_name, email, phone, avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (response != null) {
        fullNameController.text = response['full_name'] ?? '';
        emailController.text = response['email'] ?? user.email ?? '';
        phoneController.text = response['phone'] ?? '';
        avatarUrl.value = response['avatar_url'] ?? '';
      } else {
        emailController.text = user.email ?? '';
      }
    } catch (e) {
      print('Error loading profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // --- 2. PILIH FOTO DARI GALERI ---
  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      // Pilih gambar dari galeri HP
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600, // Kompres biar upload cepet
        imageQuality: 80,
      );

      if (image != null) {
        selectedImage.value = File(image.path);
        // Otomatis upload saat user selesai milih foto
        await _uploadAvatar(); 
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal ambil foto: $e', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // --- 3. UPLOAD KE STORAGE & UPDATE DB ---
  Future<void> _uploadAvatar() async {
    if (selectedImage.value == null) return;

    try {
      isUploadingImage.value = true;
      final user = _supabase.currentUser;
      if (user == null) throw Exception('User tidak ditemukan');

      // Nama file unik: user_id + timestamp
      final fileName = '${user.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'avatars/$fileName';

      // A. Upload ke Supabase Storage (Bucket: product-images)
      await _supabase.client.storage
          .from('product-images')
          .upload(path, selectedImage.value!);

      // B. Ambil Public URL
      final imageUrl = _supabase.client.storage
          .from('product-images')
          .getPublicUrl(path);

      // C. Update URL ke Tabel Profiles
      // PENTING: .select() wajib ada!
      await _supabase.client
          .from('profiles')
          .update({'avatar_url': imageUrl})
          .eq('id', user.id)
          .select();

      // Update tampilan lokal
      avatarUrl.value = imageUrl;
      
      Get.snackbar('Berhasil', 'Foto profil berhasil diganti!', 
        backgroundColor: Colors.green, colorText: Colors.white);

      // Refresh halaman Akun utama
      try { Get.find<AccountController>().loadUserData(); } catch (_) {}

    } catch (e) {
      Get.snackbar('Gagal Upload', 'Error: $e', 
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploadingImage.value = false;
    }
  }

  // --- 4. SIMPAN DATA TEKS ---
  Future<void> saveProfile() async {
    if (fullNameController.text.isEmpty) {
      Get.snackbar('Error', 'Nama tidak boleh kosong', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      final user = _supabase.currentUser;
      if (user == null) throw Exception('Login dulu');

      // Update data teks
      // PENTING: .select() wajib ada!
      await _supabase.client.from('profiles').update({
        'full_name': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', user.id).select();

      Get.snackbar('Sukses', 'Profil berhasil diperbarui!', 
        backgroundColor: Colors.green, colorText: Colors.white);
      
      try { Get.find<AccountController>().loadUserData(); } catch (_) {}
      
      // Tunggu sebentar biar snackbar kebaca, baru back
      await Future.delayed(const Duration(seconds: 1));
      Get.back();

    } catch (e) {
      Get.snackbar('Gagal', 'Error menyimpan data: $e', 
        backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}