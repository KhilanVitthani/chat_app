import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/text_field.dart';
import '../controllers/temp_chat_controller.dart';

class TempChatView extends GetView<TempChatController> {
  const TempChatView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: () {
                  if (controller.isFromNotification) {
                    Get.offAllNamed(Routes.HOME);
                  } else {
                    Get.back();
                  }
                }),
            title: getTitle(),
            centerTitle: true,
          ),
          body: Container(
            child: Column(
              children: [
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  stream: getIt<FirebaseService>()
                      .getChatData(chatId: controller.getChatId()),
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text("Something went wrong......."),
                      );
                    } else if (snapShot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapShot.hasData) {
                      controller.chatDataList.clear();
                      var data = snapShot.data!.docs;
                      if (!isNullEmptyOrFalse(data)) {
                        data.forEach((element) {
                          controller.chatDataList.add(ChatDataModel.fromJson(
                              element.data() as Map<String, dynamic>));
                        });
                      }


                      FirebaseFirestore.instance
                          .collection("chat")
                          .doc(controller.getChatId())
                          .collection("chats")
                          .orderBy("dateTime", descending: false)
                          .get()
                          .then((value) {
                        for (QueryDocumentSnapshot qs in value.docs) {
                          if ((qs.data() as Map<String, dynamic>)["senderId"] ==
                              controller.friendData!.uId) {
                            qs.reference.update({"rRead": true});
                          }
                        }
                      });

                      return ListView.separated(
                        reverse: true,
                        itemCount: controller.chatDataList.length,
                        controller: controller.scrollController.value,
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.getWidth(10),
                            vertical: MySize.getHeight(10)),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: (controller
                                    .chatDataList[index].isUsersMsg!.value)
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: (!controller
                                      .chatDataList[index].isUsersMsg!.value)
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.end,
                              children: [
                                if (!(controller
                                    .chatDataList[index].isUsersMsg!.value))
                                  Container(
                                    margin: EdgeInsets.only(right: 30),
                                    padding: EdgeInsets.only(
                                        left: 0,
                                        right: 14,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment: (!controller
                                              .chatDataList[index]
                                              .isUsersMsg!
                                              .value)
                                          ? Alignment.topLeft
                                          : Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                MySize.getHeight(20)),
                                            topLeft: Radius.circular(
                                                MySize.getHeight(20)),
                                            bottomRight: Radius.circular(
                                                MySize.getHeight(20)),
                                          ),
                                          color: (!controller
                                                  .chatDataList[index]
                                                  .isUsersMsg!
                                                  .value)
                                              ? Colors.grey.shade200
                                              : Colors.blue[200],
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.chatDataList[index].msg
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Spacing.height(8),
                                            Text(
                                              DateFormat("hh:mm a").format(
                                                  controller.chatDataList[index].dateTime!),
                                              style:
                                              TextStyle(fontSize: MySize.getHeight(8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    margin: EdgeInsets.only(left: 30),
                                    padding: EdgeInsets.only(
                                        left: 14,
                                        right: 0,
                                        top: 10,
                                        bottom: 10),
                                    child: Align(
                                      alignment: (!controller
                                              .chatDataList[index]
                                              .isUsersMsg!
                                              .value)
                                          ? Alignment.topLeft
                                          : Alignment.topRight,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(
                                                MySize.getHeight(20)),
                                            topLeft: Radius.circular(
                                                MySize.getHeight(20)),
                                            bottomLeft: Radius.circular(
                                                MySize.getHeight(20)),
                                          ),
                                          color: (!controller
                                                  .chatDataList[index]
                                                  .isUsersMsg!
                                                  .value)
                                              ? Colors.grey.shade200
                                              : Colors.blue[200],
                                        ),
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              controller.chatDataList[index].msg
                                                  .toString(),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            Spacing.height(8),
                                            Text(
                                              DateFormat("hh:mm a").format(
                                                  controller.chatDataList[index].dateTime!),
                                              style:
                                              TextStyle(fontSize: MySize.getHeight(8)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                              ],
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Spacing.height(5);
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                )),
                Container(
                  padding: EdgeInsets.only(
                      left: MySize.getWidth(10),
                      right: MySize.getWidth(10),
                      bottom: MySize.getHeight(5)),
                  child: getTextField(
                    textEditingController: controller.chatController.value,
                    hintText: "Enter Text",
                    textCapitalization: TextCapitalization.sentences,
                    suffixIcon: InkWell(
                        onTap: () async {
                          if (!isNullEmptyOrFalse(
                              controller.chatController.value.text)) {
                            await getIt<FirebaseService>()
                                .addChatDataToFireStore(
                                    chatId: controller.getChatId(),
                                    chatData: {
                                  "senderId":
                                      box.read(ArgumentConstant.userUid),
                                  "receiverId": controller.friendData!.uId,
                                  "msg": controller.chatController.value.text,
                                  "dateTime":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "rRead": false,
                                  "sRead": true,
                                });
                            controller.gotoMaxScrooll();
                            Map<String,dynamic>? data = await getIt<FirebaseService>().getUserNotificationStatus(chatId: controller.getChatId(),
                                context: Get.context!, uid: controller.friendData!.uId??"");
                            if (data==null||data["isOnline"]!=true) {
                              await controller.sendPushNotification(
                                nTitle: controller.friendData!.name!,
                                nBody: controller.chatController.value.text,
                                nType: "nType",
                                nSenderId: box.read(ArgumentConstant.userUid),
                                nUserDeviceToken:
                                    controller.friendData!.fcmToken.toString(),
                              );
                            }
                            controller.chatController.value.clear();
                          }
                        },
                        child: Icon(Icons.send)),
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async {
          if (controller.isFromNotification) {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.back();
          }
          return false;
        });
  }

  getTitle() {
    return StreamBuilder(
        stream: getIt<FirebaseService>()
            .getUserStreamData(uid: controller.friendData!.uId.toString()),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapShot) {
          if (snapShot.hasData) {
            UserModel data = UserModel.fromJson(
                snapShot.data!.data() as Map<String, dynamic>);
            controller.isUserOnline.value = data.chatStatus;
            print(data);
            return Column(
              children: [
                Text(controller.friendData!.name.toString() +
                    " " +
                    controller.friendData!.lastName.toString()),
                Spacing.height(2),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   mainAxisSize: MainAxisSize.min,
                //   children: [
                //     Text(
                //       (data.chatStatus) ? "Online" : "Offline",
                //       style: TextStyle(
                //           fontSize: MySize.getHeight(10),
                //           fontWeight: FontWeight.w300),
                //     ),
                //     Space.width(3),
                //     CircleAvatar(radius: MySize.getHeight(4),backgroundColor:(data.chatStatus) ?Colors.green: Colors.red,),
                //   ],
                // ),
              ],
            );
          }
          return Column(
            children: [
              Text(controller.friendData!.name.toString()),
              // Spacing.height(2),
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.center,                  mainAxisSize: MainAxisSize.min,
              //
              //   children: [
              //     Text(
              //       "Offline",
              //       style: TextStyle(
              //           fontSize: MySize.getHeight(10),
              //           fontWeight: FontWeight.w300),
              //     ),
              //     Space.width(3),
              //     CircleAvatar(radius: MySize.getHeight(4),backgroundColor: Colors.red,),
              //   ],
              // ),
            ],
          );
        });
  }
}
