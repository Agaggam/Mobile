import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/services/api_service.dart';
import 'package:_89_secondstufff/app/modules/cart/cart_controller.dart';

class ProductDetailController extends GetxController {
  // --- SERVICE & CONTROLLER ---
  final ApiService apiService = Get.find(); // Untuk chained request (dummy)
  final CartController cartController = Get.find(); // Untuk keranjang (Hive)

  // --- STATE UNTUK HALAMAN INI ---
  var product = Rx<Product?>(null);
  var isLoading = false.obs; // Untuk tombol "Add to Cart"

  // --- STATE UNTUK TES CHAINED REQUEST (DUMMY) ---
  var chainedProductResult = Rx<Product?>(null);
  var isChainedLoading = false.obs;
  var chainedLog = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data produk yang dikirim dari halaman sebelumnya
    final arg = Get.arguments;
    if (arg is Product) {
      product.value = arg;
    }
  }

  // --- PERBAIKAN: FUNGSI ADD TO CART ---
  // Dibuat sederhana: hanya memanggil CartController (Hive)
  void addToCart(Product product) async {
    isLoading.value = true;

    // Kita tidak perlu memanggil ApiService.addToCart lagi
    // karena CartController (Hive) sudah menangani penyimpanan

    // Cukup panggil CartController
    cartController.addToCart(product);

    // Beri jeda sedikit untuk efek "loading"
    await Future.delayed(const Duration(milliseconds: 500));

    isLoading.value = false;
  }
  // --- AKHIR PERBAIKAN ---

  // --- FUNGSI DUMMY UNTUK TES CHAINED REQUEST (DARI KODE LAMA) ---
  void runChainedAsync() async {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Async/Await...\n';
    try {
      // User ID 2 sebagai contoh (ini masih memanggil ApiService lama)
      final result = await apiService.fetchFirstProductInCartAsync(2);
      chainedProductResult.value = result;
      chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
    } catch (e) {
      chainedLog.value += 'ERROR: $e';
    } finally {
      isChainedLoading.value = false;
    }
  }

  void runChainedCallback() {
    isChainedLoading.value = true;
    chainedLog.value = 'Running Callback/Then...\n';
    apiService.fetchFirstProductInCartCallback(2).then((result) {
      chainedProductResult.value = result;
      chainedLog.value += 'SUCCESS: Fetched ${result?.title ?? 'nothing'}';
      isChainedLoading.value = false;
    }).catchError((e) {
      chainedLog.value += 'ERROR: $e';
      isChainedLoading.value = false;
    });
  }
}
