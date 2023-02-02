import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../constants/sizeConstant.dart';

class UserModel {
  String? uId;
  String? name;
  String? lastName;
  String? email;
  // String? password;
  String? fcmToken;
  int? timeStamp;
  String? imgUrl;
  int? level;
  GeoPoint? latLng;
  bool? isVerified = false;
  bool chatStatus = false;
  List<dynamic>? friendsList = [];
  List<dynamic>? requestedFriendsList = [];

  UserModel(
      {required this.uId,
      required this.name,
      required this.lastName,
      required this.email,
      // required this.password,
      required this.friendsList,
      required this.level,
      this.isVerified,
      required this.latLng,
      required this.requestedFriendsList,
      required this.imgUrl,
      required this.chatStatus,
      required this.timeStamp});

  UserModel.fromJson(Map<String, dynamic> json) {
    uId = json['uId'];
    name = json['name'];
    lastName = json['lastName'];
    email = json['email'];
    // password = json['password'];
    friendsList = json["friendsList"] ?? [];
    level = json["level"];
    latLng = json['latLng'] ?? GeoPoint(0, 0);
    isVerified = json["isVerified"] ?? false;
    imgUrl = json["imgUrl"];
    fcmToken = json["FCM"];
    timeStamp = json["timeStamp"];

    requestedFriendsList = json["requestedFriendsList"] ?? [];
    if (!isNullEmptyOrFalse(json["inChatScreen"])) {
      chatStatus = json["inChatScreen"];
    } else {
      chatStatus = false;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uId'] = this.uId;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['level'] = this.level;
    data['timeStamp'] = DateTime.now().toUtc().millisecondsSinceEpoch;
    // data['password'] = this.password;
    data['imgUrl'] = this.imgUrl;
    data['latLng'] = this.latLng;
    data['isVerified'] = this.isVerified ?? false;
    data['friendsList'] = this.friendsList;
    data['inChatScreen'] = this.chatStatus;
    data['requestedFriendsList'] = this.requestedFriendsList;
    return data;
  }
}
