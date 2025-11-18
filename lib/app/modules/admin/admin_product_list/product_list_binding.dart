import 'package:get/get.dart';
import 'product_list_controller.dart';

class AdminProductListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductListController>(
      () => AdminProductListController(),
    );
  }
}
