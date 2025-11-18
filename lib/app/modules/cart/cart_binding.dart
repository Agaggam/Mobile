import 'package:get/get.dart';
import 'cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    // Kita gunakan lazyPut di sini
    // Controller-nya sendiri akan kita 'put' secara global di main.dart
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}
