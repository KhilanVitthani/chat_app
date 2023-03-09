import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';
import '../../../utilities/text_field.dart';
import '../controllers/chat_screen_controller.dart';

class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({Key? key}) : super(key: key);

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
                    child: StreamBuilder(
                  stream: controller.listenToChatsRealTime(),
                  builder: (context, snapShot) {
                    if (snapShot.hasError) {
                      return Center(
                        child: Text("Something went wrong......."),
                      );
                    }
                    if (snapShot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapShot.hasData) {
                      controller.chatDataList.clear();

                      if (!isNullEmptyOrFalse(snapShot.data)) {
                        (snapShot.data as List<ChatDataModel>)
                            .forEach((element) {
                          controller.chatDataList.add(element);
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
                      if (controller.chatDataList.length > 0) {
                        return GroupedListView<ChatDataModel, String>(
                          elements: controller.chatDataList,
                          controller: controller.scrollController.value,
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getWidth(10),
                              vertical: MySize.getHeight(10)),
                          reverse: true,
                          // useStickyGroupSeparators: true,

                          groupBy: (element) => element.dateTime!
                              .toLocal()
                              .toString()
                              .substring(0, 10),
                          groupComparator: (value1, value2) =>
                              value1.compareTo(value2),
                          itemComparator: (item1, item2) =>
                              (item1.dateTime!).compareTo(item2.dateTime!),

                          groupSeparatorBuilder: (String value) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Expanded(child: Container(
                                //   height: MySize.getHeight(1),
                                //   color: Colors.black.withOpacity(0.5),
                                // ),),
                                // Space.width(6),
                                FutureBuilder(
                                  builder: (context, snap) {
                                    if (snap.hasData) {
                                      return Text(
                                        snap.data.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: MySize.getHeight(14),
                                            fontWeight: FontWeight.bold),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                  future: getTitleWithDay(value),
                                ),
                                // Text(
                                //   getTitleWithDay(value),
                                //   textAlign: TextAlign.center,
                                //   style: TextStyle(
                                //       fontSize: MySize.getHeight(14),
                                //       fontWeight: FontWeight.bold),
                                // ),
                                // Space.width(6),

                                // Expanded(child: Container(
                                //   height: MySize.getHeight(1),
                                //   color: Colors.black.withOpacity(0.5),
                                // ),),
                              ],
                            ),
                          ),
                          itemBuilder: (c, element) {
                            return Align(
                              alignment: (element.isUsersMsg!.value)
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: (!element.isUsersMsg!.value)
                                    ? CrossAxisAlignment.start
                                    : CrossAxisAlignment.end,
                                children: [
                                  if (!(element.isUsersMsg!.value))
                                    Container(
                                      margin: EdgeInsets.only(right: 30),
                                      padding: EdgeInsets.only(
                                          left: 0,
                                          right: 14,
                                          top: 10,
                                          bottom: 10),
                                      child: Align(
                                        alignment: (!element.isUsersMsg!.value)
                                            ? Alignment.topLeft
                                            : Alignment.topRight,
                                        child: GestureDetector(
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
                                              color:
                                                  (!element.isUsersMsg!.value)
                                                      ? Colors.grey.shade200
                                                      : Colors.blue[200],
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  element.msg.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: (extractEmailsFromString(element
                                                                          .msg
                                                                          .toString())
                                                                      .length >
                                                                  0 ||
                                                              extractMobilesFromString(element
                                                                          .msg!)
                                                                      .length >
                                                                  0)
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      decoration: (extractEmailsFromString(element
                                                                          .msg
                                                                          .toString())
                                                                      .length >
                                                                  0 ||
                                                              extractMobilesFromString(
                                                                          element
                                                                              .msg!)
                                                                      .length >
                                                                  0)
                                                          ? TextDecoration
                                                              .underline
                                                          : null),
                                                ),
                                                Spacing.height(8),
                                                Text(
                                                  DateFormat("hh:mm a").format(
                                                      element.dateTime!),
                                                  style: TextStyle(
                                                      fontSize:
                                                          MySize.getHeight(8)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            if (extractMobilesFromString(
                                                        element.msg.toString())
                                                    .length >
                                                0) {
                                              Uri phoneNo = Uri.parse(
                                                  'tel:${extractMobilesFromString(element.msg.toString())[0]}');
                                              if (await launchUrl(phoneNo)) {
                                                //dialer opened
                                              } else {
                                                //dailer is not opened
                                              }
                                            } else if (extractEmailsFromString(
                                                        element.msg.toString())
                                                    .length >
                                                0) {
                                              Uri Email = Uri.parse(
                                                  'mailto:${extractEmailsFromString(element.msg!)[0]}');
                                              if (await launchUrl(Email)) {
                                                //Mail opened
                                              } else {
                                                //Mail is not opened
                                              }
                                            }
                                          },
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
                                        alignment: (!element.isUsersMsg!.value)
                                            ? Alignment.topLeft
                                            : Alignment.topRight,
                                        child: GestureDetector(
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
                                              color:
                                                  (!element.isUsersMsg!.value)
                                                      ? Colors.grey.shade200
                                                      : Colors.blue[200],
                                            ),
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  element.msg.toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: (extractEmailsFromString(element
                                                                          .msg
                                                                          .toString())
                                                                      .length >
                                                                  0 ||
                                                              extractMobilesFromString(element
                                                                          .msg!)
                                                                      .length >
                                                                  0)
                                                          ? Colors.blue
                                                          : Colors.black,
                                                      decoration: (extractEmailsFromString(element
                                                                          .msg
                                                                          .toString())
                                                                      .length >
                                                                  0 ||
                                                              extractMobilesFromString(
                                                                          element
                                                                              .msg!)
                                                                      .length >
                                                                  0)
                                                          ? TextDecoration
                                                              .underline
                                                          : null),
                                                ),
                                                Spacing.height(8),
                                                Text(
                                                  DateFormat("hh:mm a").format(
                                                      element.dateTime!
                                                          .toLocal()),
                                                  style: TextStyle(
                                                      fontSize:
                                                          MySize.getHeight(8)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          onTap: () async {
                                            if (extractMobilesFromString(
                                                        element.msg.toString())
                                                    .length >
                                                0) {
                                              Uri phoneNo = Uri.parse(
                                                  'tel:${extractMobilesFromString(element.msg.toString())[0]}');
                                              if (await launchUrl(phoneNo)) {
                                                //dialer opened
                                              } else {
                                                //dailer is not opened
                                              }
                                            } else if (extractEmailsFromString(
                                                        element.msg.toString())
                                                    .length >
                                                0) {
                                              Uri Email = Uri.parse(
                                                  'mailto:${extractEmailsFromString(element.msg!)[0]}');
                                              if (await launchUrl(Email)) {
                                                //Mail opened
                                              } else {
                                                //Mail is not opened
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                          order: GroupedListOrder.DESC,
                        );
                      } else {
                        return Center(
                          child: Text("No any message found."),
                        );
                      }
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
                          DateTime now = await getNtpTime();
                          if (!isNullEmptyOrFalse(
                              controller.chatController.value.text)) {
                            String msg = controller.chatController.value.text;
                            controller.chatController.value.clear();
                            await getIt<FirebaseService>()
                                .addChatDataToFireStore(
                                    chatId: controller.getChatId(),
                                    chatData: {
                                  "senderId":
                                      box.read(ArgumentConstant.userUid),
                                  "receiverId": controller.friendData!.uId,
                                  "msg": msg,
                                  "dateTime":
                                      now.toUtc().millisecondsSinceEpoch,
                                  "rRead": false,
                                  "sRead": true,
                                });
                            controller.gotoMaxScrooll();
                            await getIt<FirebaseService>().updateFriendsTime(
                                friendId: controller.friendData!.uId ?? "",
                                docId: controller.docId);

                            UserModel? userData =
                                await getIt<FirebaseService>().getUserData(
                              context: Get.context!,
                              uid: controller.friendData!.uId ?? "",
                              isLoad: false,
                            );
                            Map<String, dynamic>? data =
                                await getIt<FirebaseService>()
                                    .getUserNotificationStatus(
                                        chatId: controller.getChatId(),
                                        context: Get.context!,
                                        isLoad: false,
                                        uid: controller.friendData!.uId ?? "");
                            if (userData == null ||
                                data == null ||
                                data["isOnline"] != true) {
                              await controller.sendPushNotification(
                                nTitle: controller.friendData!.name! +
                                    " " +
                                    controller.friendData!.lastName.toString(),
                                nBody: msg,
                                nType: "nType",
                                nSenderId: box.read(ArgumentConstant.userUid),
                                nUserDeviceToken: userData!.fcmToken.toString(),
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

  getTitleWithDay(String date) async {
    DateTime now =
        getDateFromStringFromUtc(date.toString(), formatter: "yyyy-MM-dd");
    int i = await WithoutUTC(now);
    if (i == 0) {
      return "Today";
    } else if (i == -1) {
      return "Yesterday";
    } else {
      return DateFormat("MMM dd, yyyy")
          .format(getDateFromStringFromUtc(date, formatter: "yyyy-MM-dd"));
    }
  }

  // getTitleWithDay(DateTime date) {
  //   DateTime now = date.toUtc();
  //   int i = calculateDifference(now);
  //   if (i == 0) {
  //     return DateFormat("hh:mm a").format(date.toLocal());
  //   } else if (i == -1) {
  //     return "Yesterday";
  //   } else {
  //     return DateFormat("dd/MM/yy").format(date.toLocal());
  //   }
  // }

  List<String> extractEmailsFromString(String string) {
    final emailPattern = RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
        caseSensitive: false, multiLine: true);
    final matches = emailPattern.allMatches(string);
    final List<String> emails = [];
    if (matches != null) {
      for (final Match match in matches) {
        emails.add(string.substring(match.start, match.end));
      }
    }

    return emails;
  }

  List<String> extractMobilesFromString(String string) {
    final emailPattern = RegExp(
        r'\b[+]*[(]{0,1}[6-9]{1,4}[)]{0,1}[-\s\.0-9]*\b',
        caseSensitive: false,
        multiLine: true);
    final matches = emailPattern.allMatches(string);
    final List<String> emails = [];
    if (matches != null) {
      for (final Match match in matches) {
        emails.add(string.substring(match.start, match.end));
      }
    }

    return emails;
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
                Text(
                  controller.friendData!.name.toString().trim() +
                      " " +
                      controller.friendData!.lastName.toString().trim(),
                  style: TextStyle(wordSpacing: 0),
                ),
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
// bool validateMobile(String value) {
//   String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
//   RegExp regExp = new RegExp(pattern);
//   if (value.length == 0) {
//     return false;
//   } else if (!regExp.hasMatch(value)) {
//     return false;
//   }
//   return true;
// }
// }
