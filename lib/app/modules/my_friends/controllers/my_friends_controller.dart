import 'package:carousel_slider/carousel_controller.dart';
import 'package:chat_app/app/constants/sizeConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class MyFriendsController extends GetxController {
  //TODO: Implement MyFriendsController

  final count = 0.obs;
  UserModel? userData;
  RxString userName = "".obs;
  RxBool hasData = false.obs;
  Rx<CarouselController> carouselController = CarouselController().obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!,
            uid: box.read(ArgumentConstant.userUid),
            isLoad: false);
        if (!isNullEmptyOrFalse(userData)) {
          userName.value = userData!.name.toString();
          // getIt<FirebaseService>().setStatusForChatScreen(status: true);
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
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
