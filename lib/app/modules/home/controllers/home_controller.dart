import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../provider/UserDataProvider.dart';
import '../../../service/database_helper.dart';
import '../../../service/firebase_service.dart';
import '../../../service/notification_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement HomeController

  final count = 0.obs;
  UserModel? userData;
  RxString userName = "".obs;
  RxBool hasData = false.obs;

  RxInt selectedIndex = 0.obs;
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await MyDatabase.dbCreate();
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!,
            uid: box.read(ArgumentConstant.userUid),
            isLoad: false);
        if (!isNullEmptyOrFalse(userData)) {
          userName.value = userData!.name.toString();
          getIt<FirebaseService>().setStatusForChatScreen(status: true);
        }
        print(userData);
      }
      if (!isNullEmptyOrFalse(userData)) {
        final provider =
            Provider.of<UserDataProvider>(Get.context!, listen: false);
        provider.setUserData(userData!);
        String fcmToken = await getIt<NotificationService>().getFcmToken();
        if (!isNullEmptyOrFalse(fcmToken)) {
          await getIt<FirebaseService>().updateFcmToken(fcmToken: fcmToken);
        }
      }
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
