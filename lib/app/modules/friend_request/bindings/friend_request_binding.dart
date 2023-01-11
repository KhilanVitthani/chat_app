import 'package:get/get.dart';

import '../controllers/friend_request_controller.dart';

class FriendRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FriendRequestController>(
      () => FriendRequestController(),
    );
  }
}
