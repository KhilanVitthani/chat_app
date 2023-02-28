import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../provider/UserDataProvider.dart';
import '../../../provider/card_provider.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';

class AddUserController extends GetxController {
  //TODO: Implement AddUserController

  final count = 0.obs;
  UserModel? userData;
  RxBool hasData = false.obs;
  RxInt lastUpdated = 0.obs;
  Rx<CarouselController> carouselController = CarouselController().obs;
  Rx<TextEditingController> messageController = TextEditingController().obs;
  HomeController homeController = Get.find<HomeController>();
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!,
            uid: box.read(ArgumentConstant.userUid),
            isLoad: false);
        print(userData);
      }
      hasData.value = true;
      final cardProvider =
          Provider.of<CardProvider>(Get.context!, listen: false);
      final provider =
          Provider.of<UserDataProvider>(Get.context!, listen: false);

      lastUpdated.value = provider.userData!.lastUpdatedAt ?? 0;
      if (lastUpdated == 0) {
        DateTime now = await getNtpTime();
        lastUpdated.value = now.toUtc().millisecondsSinceEpoch;
      }

      cardProvider.reset();
    });
    super.onInit();
  }

  String getChatId(uid) {
    List<String> uids = [box.read(ArgumentConstant.userUid), uid.toString()];
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
            'click_action': 'FRIEND_REQUEST',
            "N_TYPE": nType,
            "N_SENDER_ID": nSenderId,
            'call_info': nCallInfo, // Call Info Data
            'status': 'done',
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

  void increment() => count.value++;
}
