import 'package:chat_app/app/utilities/date_utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../provider/UserDataProvider.dart';
import '../../../service/firebase_service.dart';
import '../../../service/notification_service.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement HomeController

  final count = 0.obs;
  UserModel? userData;
  RxString userName = "".obs;
  RxBool hasData = false.obs;
  RxBool hasUserData = false.obs;
  RxInt selectedIndex = 0.obs;
  RxInt lastUpdated = 0.obs;

  RxList<UserModel> userList = RxList([]);
  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      DateTime now = await getNtpTime();

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
        getRandomUserList();
      }
      if (!isNullEmptyOrFalse(userData)) {
        final provider =
            Provider.of<UserDataProvider>(Get.context!, listen: false);
        provider.setUserData(userData!);
        lastUpdated.value = provider.userData!.lastUpdatedAt ?? 0;
        if (lastUpdated == 0) {
          lastUpdated.value = now.millisecondsSinceEpoch;
        }
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

  getRandomUserList() async {
    hasUserData.value = false;
    RxList<UserModel> user = RxList([]);
    RxList<UserModel> user1 =
        (await getIt<FirebaseService>().getAllUsersFutureList()).obs;
    user1.forEach((element) {
      if (!userData!.friendsList!.contains(element.uId)) {
        user.add(element);
      }
    });
    user.shuffle();
    userList = (user.length > 5) ? user.sublist(0, 5).obs : user;
    userList.forEach((element) {
      print(element.name.toString());
    });
    userList.refresh();
    update();
    hasUserData.value = true;
  }

  @override
  void onClose() {
    super.onClose();
    getIt<FirebaseService>().setStatusForChatScreen(status: false);
    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
