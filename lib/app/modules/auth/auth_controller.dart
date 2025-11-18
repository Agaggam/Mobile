import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// --- IMPORT BARU ---
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';

class AuthController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  final TextEditingController emailController = TextEditingController(
    text: '', // Ganti ke email Anda yang 'admin'
  );
  final TextEditingController passwordController = TextEditingController(
    text: '',
  );
  var isLoadingLogin = false.obs;
  var isLoginPasswordHidden = true.obs;

  final TextEditingController emailSignUpController = TextEditingController();
  final TextEditingController passwordSignUpController =
      TextEditingController();
  var isLoadingSignUp = false.obs;
  var isSignUpPasswordHidden = true.obs;

  void toggleLoginPasswordVisibility() {
    isLoginPasswordHidden.value = !isLoginPasswordHidden.value;
  }

  void toggleSignUpPasswordVisibility() {
    isSignUpPasswordHidden.value = !isSignUpPasswordHidden.value;
  }

  // --- MODIFIKASI BESAR: signInWithEmail ---
  void signInWithEmail() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoadingLogin.value = true;
    try {
      // 1. Sukses Login
      final authResponse =
          await _supabaseService.client.auth.signInWithPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // 2. Ambil User ID
      final userId = authResponse.user?.id;
      if (userId == null) {
        throw Exception("User tidak ditemukan setelah login.");
      }

      // 3. Cek 'role' dari tabel 'profiles'
      final profileResponse = await _supabaseService.client
          .from('profiles')
          .select('id, email, role')
          .eq('id', userId)
          .single();

      // Buat model Profile (meskipun hanya 'role' yang kita ambil)
      final profile = Profile.fromJson(profileResponse);

      isLoadingLogin.value = false;

      // 4. Navigasi berdasarkan 'role'
      if (profile.role == 'admin') {
        Get.offAllNamed(AppRoutes.ADMIN_HOME);
      } else {
        Get.offAllNamed(AppRoutes.MAIN_NAVIGATION);
      }
    } on AuthException catch (e) {
      isLoadingLogin.value = false;
      Get.snackbar(
        'Login Gagal',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoadingLogin.value = false;
      Get.snackbar(
        'Login Gagal',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // --- FUNGSI SIGN UP (Tidak Berubah) ---
  void signUpWithEmail() async {
    if (emailSignUpController.text.isEmpty ||
        passwordSignUpController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Email dan password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoadingSignUp.value = true;
    try {
      // Panggil Supabase Auth untuk Sign Up
      // Trigger 'handle_new_user' akan otomatis membuat profile
      await _supabaseService.client.auth.signUp(
        email: emailSignUpController.text,
        password: passwordSignUpController.text,
      );

      isLoadingSignUp.value = false;

      Get.snackbar(
        'Registrasi Berhasil',
        'Silakan cek email Anda untuk verifikasi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.back();
    } on AuthException catch (e) {
      isLoadingSignUp.value = false;
      Get.snackbar(
        'Registrasi Gagal',
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      isLoadingSignUp.value = false;
      Get.snackbar(
        'Registrasi Gagal',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void goToSignUp() {
    Get.toNamed(AppRoutes.SIGNUP);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailSignUpController.dispose();
    passwordSignUpController.dispose();
    super.onClose();
  }
}
