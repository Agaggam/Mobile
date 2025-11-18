import 'package:get/get.dart';
import 'package:flutter/material.dart';
// --- IMPORT BARU ---
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;
  // Kunci untuk menyimpan di SharedPreferences (sesuai modul)
  static const String _themeKey = 'isDarkTheme';

  // --- FUNGSI BARU (dipanggil oleh main.dart) ---
  Future<void> initTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Baca tema yang tersimpan, jika tidak ada, defaultnya 'false' (light mode)
      final isDark = prefs.getBool(_themeKey) ?? false;
      isDarkMode.value = isDark;
      _updateThemeMode();
    } catch (e) {
      print("Gagal memuat tema: $e");
      isDarkMode.value = false;
      _updateThemeMode();
    }
  }

  // --- MODIFIKASI: toggleTheme() sekarang juga menyimpan ---
  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    _updateThemeMode();

    // Simpan preferensi baru ke SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_themeKey, isDarkMode.value);
    } catch (e) {
      print("Gagal menyimpan tema: $e");
    }
  }

  // --- HELPER BARU ---
  void _updateThemeMode() {
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
