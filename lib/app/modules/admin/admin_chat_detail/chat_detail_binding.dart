import 'package:get/get.dart';
import 'chat_detail_controller.dart';

class AdminChatDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminChatDetailController>(
      () => AdminChatDetailController(),
    );
  }
}
