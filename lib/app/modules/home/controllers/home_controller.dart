import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  UserModel? userData;
  RxString userName = "".obs;
  RxBool hasData = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!, uid: box.read(ArgumentConstant.userUid));
        if (!isNullEmptyOrFalse(userData)) {
          userName.value = userData!.name.toString();
        }
        print(userData);
      }
      // if (!isNullEmptyOrFalse(userData)) {
      //   String fcmToken = await getIt<NotificationService>().getFcmToken();
      //   if (!isNullEmptyOrFalse(fcmToken)) {
      //     await getIt<FirebaseService>().updateFcmToken(fcmToken: fcmToken);
      //   }
      // }
      hasData.value = true;
    });
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
