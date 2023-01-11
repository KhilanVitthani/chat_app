import 'package:get/get.dart';

import '../../main.dart';
import '../constants/app_constant.dart';

class ChatDataModel {
  String? msg;
  String? senderId;
  String? receiverId;
  DateTime? dateTime;
  RxBool? isUsersMsg = false.obs;
  ChatDataModel({this.msg, this.isUsersMsg, this.receiverId, this.senderId});
  ChatDataModel.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    senderId = json["senderId"];
    receiverId = json["receiverId"];
    isUsersMsg!.value =
        (json["senderId"] == box.read(ArgumentConstant.userUid));
    dateTime = DateTime.fromMillisecondsSinceEpoch(json["dateTime"]);
  }
}
