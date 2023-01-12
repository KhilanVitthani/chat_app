import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';

class TempChatController extends GetxController with WidgetsBindingObserver {
  //TODO: Implement TempChatController
  UserModel? friendData;
  Rx<TextEditingController> chatController = TextEditingController().obs;
  RxList<ChatDataModel> chatDataList = RxList<ChatDataModel>([]);
  RxBool isUserOnline = false.obs;
  bool isFromNotification = false;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (!isNullEmptyOrFalse(Get.arguments)) {
      friendData = Get.arguments[ArgumentConstant.userData];
      isFromNotification = !isNullEmptyOrFalse(
          Get.arguments[ArgumentConstant.isFromNotification]);
    }
    // WidgetsBinding.instance.addObserver(this);
  }

  String getChatId() {
    List<String> uids = [
      box.read(ArgumentConstant.userUid),
      friendData!.uId.toString()
    ];
    uids.sort((uid1, uid2) => uid1.compareTo(uid2));
    return uids.join("_chat_");
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
