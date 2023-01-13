import 'package:get/get.dart';

import '../../main.dart';
import '../constants/app_constant.dart';

class ChatDataModel {
  String? msg;
  String? senderId;
  String? receiverId;
  DateTime? dateTime;
  RxBool? isUsersMsg = false.obs;
  bool? isImage;
  String? imageUrl;
  bool? sRead;
  String? chatId;
  bool? rRead;
  ChatDataModel({
    this.msg,
    this.isUsersMsg,
    this.receiverId,
    this.senderId,
    this.isImage,
    this.dateTime,
    this.imageUrl,
    this.sRead,
    this.chatId,
    this.rRead,

  });
  ChatDataModel.fromJson(Map<String, dynamic> json) {
    msg = json["msg"];
    senderId = json["senderId"];
    receiverId = json["receiverId"];
    isUsersMsg!.value =
        (json["senderId"] == box.read(ArgumentConstant.userUid));
    dateTime = DateTime.fromMillisecondsSinceEpoch(json["dateTime"]);
    imageUrl = json['imageUrl'];
    sRead = json['sRead'];
    chatId = json['chatId'];
    rRead = json['rRead'];
  }
}
