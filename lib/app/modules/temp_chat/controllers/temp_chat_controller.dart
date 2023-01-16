import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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
  Rx<ScrollController> scrollController = ScrollController().obs;

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    if (!isNullEmptyOrFalse(Get.arguments)) {
      friendData = Get.arguments[ArgumentConstant.userData];
      isFromNotification = !isNullEmptyOrFalse(
          Get.arguments[ArgumentConstant.isFromNotification]);
      getIt<FirebaseService>().setStatusForNotificationChatScreen(
          status: true, chatId: getChatId());
    }
    WidgetsBinding.instance.addObserver(this);
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

  gotoMaxScrooll() {
    Timer(
      const Duration(
        milliseconds: 200,
      ),
      () {
        scrollController.value
            .jumpTo(scrollController.value.position.minScrollExtent);
      },
    );
  }
  Future<void> sendPushNotification({
    required String nTitle,
    required String nBody,
    required String nType,
    required String nSenderId,
    required String nUserDeviceToken,
    // Call Info Map Data
    Map<String, dynamic>? nCallInfo,
  }) async {
    // Variables
    final Uri url = Uri.parse('https://fcm.googleapis.com/fcm/send');

    await http
        .post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'key=AAAAoICxc_o:APA91bHEIwawAazThtHUn0iv-9xgKBe0CMet-sA6WE2VE0qvujFg9qSKqrpsSeytHei-jtdMI0_h2aVURTyG_CwTH0CdW9LT04Xv8smdsXQhWFPMEWVHC2CMCUyxvZcSxILkzwcrBwZa',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'title': nTitle,
            'body': nBody,
            'color': '#F1F7B5',
            'priority': 'high',
            'sound': "default"
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            "N_TYPE": nType,
            "N_SENDER_ID": nSenderId,
            "chatId":getChatId(),
            'call_info': nCallInfo, // Call Info Data
            'status': 'done'
          },
          'to': nUserDeviceToken,
        },
      ),
    )
        .then((http.Response response) {
      if (response.statusCode == 200) {
        print('sendPushNotification() -> success');
      }
    }).catchError((error) {
      print('sendPushNotification() -> error: $error');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());

        break;
      case AppLifecycleState.resumed:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: true, chatId: getChatId());

        break;
      case AppLifecycleState.detached:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());

        break;
      case AppLifecycleState.inactive:
        getIt<FirebaseService>().setStatusForNotificationChatScreen(
            status: false, chatId: getChatId());
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void onClose() {
    super.onClose();
    getIt<FirebaseService>()
        .setStatusForNotificationChatScreen(status: false, chatId: getChatId());

    WidgetsBinding.instance.removeObserver(this);
  }

  void increment() => count.value++;
}
