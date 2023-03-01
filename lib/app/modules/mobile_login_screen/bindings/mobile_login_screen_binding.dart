import 'package:get/get.dart';

import '../controllers/mobile_login_screen_controller.dart';

class MobileLoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileLoginScreenController>(
      () => MobileLoginScreenController(),
    );
  }
}
