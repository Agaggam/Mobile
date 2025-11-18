import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
import 'package:_89_secondstufff/app/themes/app_theme.dart';
import 'package:_89_secondstufff/app/themes/theme_controller.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';
import 'package:_89_secondstufff/app/data/services/supabase_service.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/data/services/local_storage_service.dart';
import 'package:_89_secondstufff/app/data/models/profiles_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Tema
  final themeController = Get.put(ThemeController());
  await themeController.initTheme();

  // 2. Inisialisasi Supabase & Hive
  // Kita simpan instance SupabaseService untuk pengecekan sesi nanti
  final supabaseService = await Get.putAsync(() => SupabaseService().init());
  await Get.putAsync(() => LocalStorageService().init());

  // 3. Daftarkan service & controller lain
  Get.put(ApiService());
  Get.put(CartController());
  Get.put(ProductProvider());

  // --- LOGIKA AUTO-LOGIN ---
  // Tentukan rute awal berdasarkan status sesi
  String initialRoute = AppRoutes.LOGIN;

  // Cek apakah ada user yang sedang login (session valid)
  final currentUser = supabaseService.currentUser;

  if (currentUser != null) {
    try {
      // Jika ada user, kita perlu cek role-nya untuk menentukan arah (Admin/User)
      // Kita lakukan query singkat ke tabel profiles
      final profileResponse = await supabaseService.client
          .from('profiles')
          .select('role')
          .eq('id', currentUser.id)
          .maybeSingle();

      if (profileResponse != null) {
        final profile = Profile.fromJson(profileResponse);
        if (profile.role == 'admin') {
          initialRoute = AppRoutes.ADMIN_HOME;
        } else {
          initialRoute = AppRoutes.MAIN_NAVIGATION;
        }
      }
    } catch (e) {
      // Jika terjadi error saat cek role (misal koneksi buruk),
      // amannya tetap ke login atau bisa ke home user sebagai default.
      print("Error checking role during auto-login: $e");
      // Opsional: Tetap ke login agar user login ulang
    }
  }
  // -----------------------

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute; // Terima initialRoute dari main

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        title: '89secondStuff',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: Get.find<ThemeController>().isDarkMode.value
            ? ThemeMode.dark
            : ThemeMode.light,
        // --- GUNAKAN RUTE YANG DITENTUKAN ---
        initialRoute: initialRoute,
        // ------------------------------------
        getPages: AppPages.routes,
        unknownRoute: GetPage(
          name: '/notfound',
          page: () => Scaffold(
            appBar: AppBar(title: const Text('404 - Not Found')),
            body: const Center(
              child: Text('Halaman tidak ditemukan'),
            ),
          ),
        ),
      ),
    );
  }
}
