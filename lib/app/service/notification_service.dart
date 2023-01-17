import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../main.dart';
import '../constants/app_constant.dart';
import '../constants/sizeConstant.dart';
import '../model/user_model.dart';
import '../routes/app_pages.dart';
import 'firebase_service.dart';

class NotificationService {
  Future<void> init(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    if (!isFlutterLocalNotificationInitialize) {
      var androidInitialize =
          AndroidInitializationSettings("notification_icon");
      var iosInitialize = DarwinInitializationSettings();
      var initializationSettings = InitializationSettings(
          android: androidInitialize, iOS: iosInitialize);
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse response) async {
        print(response);
        if (!isNullEmptyOrFalse(response.payload)) {
          await getNavigateToChatScreen(
              userId: jsonDecode(response.payload!)["N_SENDER_ID"],
              docId: jsonDecode(response.payload!)["docId"]);
        }
      });
      await initServices();
      try {
        await getFcmToken();
      } catch (e) {}
    }

    isFlutterLocalNotificationInitialize = true;
  }

  Future<String> getFcmToken() async {
    String fcmToken = "";

    if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken() ?? "";
    } else {
      fcmToken = await FirebaseMessaging.instance.getAPNSToken() ?? "";
    }
    return fcmToken;
  }

  initServices() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then((value) async {
      if (!isNullEmptyOrFalse(value)) {
        await getNavigateToChatScreen(
            userId: value!.data["N_SENDER_ID"], docId: value.data["docId"]);
      }
    });
    //when app is open
    FirebaseMessaging.onMessage.listen((value) {
      if (!isNullEmptyOrFalse(value)) {
        showNotification(remoteMessage: value);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((value) async {
      if (!isNullEmptyOrFalse(value)) {
        print("OnTap := ${value.data["N_SENDER_ID"]}");
        await getNavigateToChatScreen(
            userId: value.data["N_SENDER_ID"], docId: value.data["docId"]);
      }
    });
  }

  void showNotification({required RemoteMessage remoteMessage}) {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      "androidChannel01",
      "androidChannel",
      description: "Android Channel Description",
      // sound: RawResourceAndroidNotificationSound("notification"),
    );
    if (!isNullEmptyOrFalse(remoteMessage.notification)) {
      print("+++++++++++>>>>>>>>>>>>>>>>>");
      flutterLocalNotificationsPlugin.show(
        0,
        remoteMessage.notification!.title,
        remoteMessage.notification!.body,
        payload: jsonEncode(remoteMessage.data),
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              sound: channel.sound,
              importance: Importance.max,
              ongoing: false,
              channelDescription: channel.description,
              playSound: true,
              priority: Priority.high,
              color: Colors.teal,
              icon: "notification_icon"),
        ),
      );
    }
  }

  getNavigateToChatScreen(
      {required String userId, required String docId}) async {
    UserModel? userModel = await getIt<FirebaseService>().getUserData(
      uid: userId,
      isLoad: false,
    );
    if (!isNullEmptyOrFalse(userModel)) {
      Get.offAllNamed(Routes.TEMP_CHAT, arguments: {
        ArgumentConstant.userData: userModel,
        ArgumentConstant.docId: docId,
        ArgumentConstant.isFromNotification: true,
      });
    }
  }
}
