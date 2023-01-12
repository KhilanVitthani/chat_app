import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
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
          getIt<FirebaseService>().setStatusForChatScreen(status: true);
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
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        getIt<FirebaseService>().setStatusForChatScreen(status: false);

        break;
      case AppLifecycleState.resumed:
        getIt<FirebaseService>().setStatusForChatScreen(status: true);

        break;
      case AppLifecycleState.detached:
        getIt<FirebaseService>().setStatusForChatScreen(status: false);

        break;
      case AppLifecycleState.inactive:
        getIt<FirebaseService>().setStatusForChatScreen(status: false);
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    getIt<FirebaseService>().setStatusForChatScreen(status: false);
    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
