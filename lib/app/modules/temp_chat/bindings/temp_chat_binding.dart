import 'package:get/get.dart';

import '../controllers/temp_chat_controller.dart';

class TempChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TempChatController>(
      () => TempChatController(),
    );
  }
}
