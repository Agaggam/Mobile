import 'package:get/get.dart';
import 'chat_list_controller.dart';

class AdminChatListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminChatListController>(
      () => AdminChatListController(),
    );
  }
}
