import 'package:get/get.dart';

import '../controllers/my_friends_controller.dart';

class MyFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyFriendsController>(
      () => MyFriendsController(),
    );
  }
}
