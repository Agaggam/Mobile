import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/routes/app_pages.dart';
// --- IMPORT BARU ---
import 'package:shared_preferences/shared_preferences.dart';

class SearchController extends GetxController {
  final ProductProvider _productProvider = Get.find<ProductProvider>();

  final TextEditingController searchC = TextEditingController();

  final _allProducts = <Product>[].obs;
  var searchResults = <Product>[].obs;

  var isLoading = true.obs; // Diubah jadi true agar loading saat init
  var hasSearched = false.obs;

  // --- STATE BARU UNTUK HISTORY ---
  static const String _historyKey = 'search_history'; // Kunci SharedPreferences
  var searchHistory = <String>[].obs;
  // --- AKHIR STATE BARU ---

  @override
  void onInit() {
    super.onInit();
    // Panggil kedua fungsi ini saat inisialisasi
    _loadSearchHistory();
    _fetchAllProducts();
  }

  // --- FUNGSI BARU: Memuat history dari SharedPreferences ---
  void _loadSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_historyKey) ?? [];
    searchHistory.assignAll(history);
  }

  // --- FUNGSI BARU: Menyimpan history ke SharedPreferences ---
  Future<void> _saveSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, searchHistory);
  }

  void _fetchAllProducts() async {
    try {
      isLoading.value = true;
      var products = await _productProvider.getAllProducts();
      _allProducts.assignAll(products);
    } catch (e) {
      Get.snackbar(
        "Error",
        "Gagal memuat data produk: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // --- MODIFIKASI: performSearch() sekarang menyimpan history ---
  void performSearch(String query) {
    final searchTerm = query.trim().toLowerCase();
    if (searchTerm.isEmpty) {
      searchResults.clear();
      hasSearched.value = false;
      return;
    }

    hasSearched.value = true;
    // Simpan ke history
    _addSearchTerm(searchTerm);

    // Filter dari daftar _allProducts
    var results = _allProducts.where((product) {
      return product.title.toLowerCase().contains(searchTerm);
    }).toList();

    searchResults.assignAll(results);
  }

  // --- FUNGSI BARU: Menambah item ke history (mencegah duplikat) ---
  void _addSearchTerm(String term) {
    // Hapus jika sudah ada (agar pindah ke atas)
    searchHistory.remove(term);
    // Tambahkan ke paling atas (paling baru)
    searchHistory.insert(0, term);
    // Batasi history, misal 10 item
    if (searchHistory.length > 10) {
      searchHistory.removeLast();
    }
    // Simpan ke SharedPreferences
    _saveSearchHistory();
  }

  // --- FUNGSI BARU: Hapus semua history ---
  void clearSearchHistory() {
    searchHistory.clear();
    _saveSearchHistory(); // Simpan list kosong
  }

  // --- FUNGSI BARU: Saat user tap item history ---
  void onHistoryTap(String query) {
    searchC.text = query; // Masukkan teks ke search bar
    performSearch(query); // Lakukan pencarian
  }
  // --- AKHIR FUNGSI BARU ---

  void clearSearch() {
    searchC.clear();
    searchResults.clear();
    hasSearched.value = false;
  }

  void goToProductDetail(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }

  @override
  void onClose() {
    searchC.dispose();
    super.onClose();
  }
}
