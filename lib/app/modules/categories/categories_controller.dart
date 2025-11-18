import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/data/models/category_model.dart'; // <-- IMPORT MODEL BARU
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class CategoriesController extends GetxController {
  // --- PERUBAHAN DI SINI ---
  final ProductProvider _productProvider = Get.find<ProductProvider>();

  var isLoading = true.obs;
  var categories = <Category>[].obs;
  // --- AKHIR PERUBAHAN ---

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // --- FUNGSI BARU ---
  void fetchCategories() async {
    try {
      isLoading.value = true;
      var fetchedCategories = await _productProvider.getCategories();
      categories.assignAll(fetchedCategories);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat kategori: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCategoryTap(Category category) {
    // Navigasi ke halaman produk berdasarkan kategori
    Get.toNamed(
      AppRoutes.CATEGORY_PRODUCTS,
      arguments: category,
    );
  }

  // --- TAMBAHAN BARU: Metode yang hilang ---
  IconData getCategoryIcon(String categoryName) {
    switch (categoryName) {
      case "electronics":
        return Icons.devices_other; // Icon untuk elektronik
      case "jewelery":
        return Icons.diamond_outlined;
      case "men's clothing":
        return Icons.man;
      case "women's clothing":
        return Icons.woman;
      default:
        return Icons.category; // Icon default
    }
  }
  // --- AKHIR TAMBAHAN ---
}
