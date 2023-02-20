import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class FriendRequestController extends GetxController {
  //TODO: Implement AddUserController

  final count = 0.obs;
  UserModel? userData;
  RxBool hasData = false.obs;
  bool isFromNotification = false;

  @override
  void onInit() {
    if (!isNullEmptyOrFalse(Get.arguments)) {
      isFromNotification = !isNullEmptyOrFalse(
          Get.arguments[ArgumentConstant.isFromNotification]);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!,
            uid: box.read(ArgumentConstant.userUid),
            isLoad: false);
        print(userData);
      }
      hasData.value = true;
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
