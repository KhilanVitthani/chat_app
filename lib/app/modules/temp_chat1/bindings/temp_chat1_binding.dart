import 'package:get/get.dart';

import '../controllers/temp_chat1_controller.dart';

class TempChat1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TempChat1Controller>(
      () => TempChat1Controller(),
    );
  }
}
