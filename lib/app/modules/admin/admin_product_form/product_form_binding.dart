import 'package:get/get.dart';
import 'product_form_controller.dart';

class AdminProductFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminProductFormController>(
      () => AdminProductFormController(),
    );
  }
}
