import 'package:get/get.dart';
import 'package:_89_secondstufff/app/data/models/product_model.dart';
import 'package:_89_secondstufff/app/data/providers/product_provider.dart';
import 'package:_89_secondstufff/app/data/models/category_model.dart'; // <-- IMPORT BARU
import 'package:_89_secondstufff/app/routes/app_pages.dart';

class CategoryProductsController extends GetxController {
  final ProductProvider _productProvider = Get.find<ProductProvider>();

  // Nama kategori yang diterima dari halaman sebelumnya
  var category = Rx<Category?>(null);

  var isLoading = true.obs;
  var products = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil objek Category yang dikirim
    final arg = Get.arguments;
    if (arg is Category) {
      category.value = arg;
    }
    fetchProductsByCategory();
  }

  void fetchProductsByCategory() async {
    if (category.value == null) {
      Get.snackbar('Error', 'Kategori tidak valid.');
      isLoading.value = false;
      return;
    }
    try {
      isLoading.value = true;
      var productList =
          await _productProvider.getProductsByCategory(category.value!.id);
      products.assignAll(productList);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memuat produk: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigasi ke detail produk
  void onProductTap(Product product) {
    Get.toNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
  }
}
