import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../Widgets/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../provider/card_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';
import '../controllers/my_friends_controller.dart';

class MyFriendsView extends GetWidget<MyFriendsController> {
  const MyFriendsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    return GetBuilder<MyFriendsController>(
        init: MyFriendsController(),
        builder: (controller) {
          return Obx(() {
            return Scaffold(
              body: (controller.hasData.isFalse)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: MySize.screenHeight,
                      child: Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: getIt<FirebaseService>()
                                  .getAllFriendsOfUser(),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.hasError) {
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child:
                                              Text("Something went wrong..."),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Column(
                                    children: [
                                      Expanded(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return (snapshot.data!.docs.length > 0)
                                      ? ListView.builder(
                                          padding: EdgeInsets.symmetric(
                                              vertical: MySize.getHeight(20),
                                              horizontal: MySize.getWidth(10)),
                                          itemCount: snapshot.data!.docs.length,
                                          itemBuilder: (context, index) {
                                            print(
                                                snapshot.data!.docs[index].id);
                                            UserModel userModel =
                                                UserModel.fromJson(snapshot
                                                        .data!.docs[index]
                                                        .data()
                                                    as Map<String, dynamic>);
                                            return (userModel.uId !=
                                                    box.read(ArgumentConstant
                                                        .userUid))
                                                ? Card(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(MySize
                                                                    .getHeight(
                                                                        10))),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Get.toNamed(
                                                            Routes.CHAT_SCREEN,
                                                            arguments: {
                                                              ArgumentConstant
                                                                      .userData:
                                                                  userModel,
                                                              ArgumentConstant
                                                                      .docId:
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                      .id,
                                                            });
                                                        // userModel.friendsList!.add(
                                                        //     controller.userData!.uId.toString());
                                                        // controller.userData!.requestedFriendsList!
                                                        //     .add(userModel.uId.toString());
                                                        // await getIt<FirebaseService>().addFriend(
                                                        //   context: context,
                                                        //   friendsModel: userModel,
                                                        //   myFriendList: controller
                                                        //       .userData!.requestedFriendsList!,
                                                        //   friendsUid: userModel.uId!,
                                                        // );
                                                        // Get.back();
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: MySize
                                                                    .getWidth(
                                                                        15),
                                                                vertical: MySize
                                                                    .getHeight(
                                                                        15)),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          200),
                                                              child: getImageByLink(
                                                                  url: userModel
                                                                          .imgUrl ??
                                                                      "",
                                                                  height: 50,
                                                                  width: 50),
                                                            ),
                                                            Space.width(20),
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Text(
                                                                          userModel.name.toString() +
                                                                              " " +
                                                                              userModel.lastName.toString(),
                                                                        ),
                                                                      ),
                                                                      Space.width(
                                                                          20),
                                                                      FutureBuilder<
                                                                              dynamic>(
                                                                          future:
                                                                              getTitleWithDay(
                                                                            DateTime.fromMillisecondsSinceEpoch(
                                                                              userModel.timeStamp!,
                                                                            ),
                                                                          ),
                                                                          builder:
                                                                              (context, snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              return Text(
                                                                                snapshot.data.toString(),
                                                                                style: TextStyle(
                                                                                  fontSize: MySize.getHeight(12),
                                                                                ),
                                                                              );
                                                                            }
                                                                            return SizedBox();
                                                                          }),

                                                                      // Space.width(
                                                                      //     20),
                                                                      // Icon(
                                                                      //   Icons
                                                                      //       .chat,
                                                                      //   color:
                                                                      //       appTheme.primaryTheme,
                                                                      //   size:
                                                                      //       MySize.getHeight(20),
                                                                      // ),
                                                                    ],
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                  ),
                                                                  Spacing
                                                                      .height(
                                                                          10),
                                                                  // Text(userModel.uId.toString()),
                                                                  Row(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            StreamBuilder(
                                                                          stream:
                                                                              getIt<FirebaseService>().getChatData(chatId: getIt<FirebaseService>().getChatId(friendUid: userModel.uId.toString())),
                                                                          builder:
                                                                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              var docList = snapshot.data!.docs;
                                                                              if (docList.isNotEmpty) {
                                                                                ChatDataModel message = ChatDataModel.fromJson(docList.first.data() as Map<String, dynamic>);
                                                                                return Text(
                                                                                  (message.isImage ?? false) ? "Image" : message.msg.toString(),
                                                                                  style: TextStyle(
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                    fontSize: MySize.getHeight(12),
                                                                                    fontWeight: (message.rRead == false && message.senderId == userModel.uId) ? FontWeight.bold : FontWeight.normal,
                                                                                  ),
                                                                                );
                                                                              } else
                                                                                return Text(
                                                                                  "No Message",
                                                                                  style: TextStyle(
                                                                                    fontSize: MySize.getHeight(12),
                                                                                    fontWeight: FontWeight.normal,
                                                                                  ),
                                                                                );
                                                                            }
                                                                            return Text(
                                                                              "Loading...",
                                                                              style: TextStyle(
                                                                                fontSize: MySize.getHeight(12),
                                                                                fontWeight: FontWeight.normal,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                      Space.width(
                                                                          20),
                                                                      StreamBuilder<
                                                                          QuerySnapshot>(
                                                                        stream: getIt<FirebaseService>().getChatData(
                                                                            chatId:
                                                                                getIt<FirebaseService>().getChatId(friendUid: userModel.uId.toString())),
                                                                        builder:
                                                                            (context,
                                                                                AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                          if (snapshot
                                                                              .hasData) {
                                                                            var docList =
                                                                                snapshot.data!.docs;
                                                                            int count =
                                                                                0;
                                                                            if (docList.isNotEmpty) {
                                                                              var data = snapshot.data!.docs;
                                                                              List<ChatDataModel> chatList = [];
                                                                              if (!isNullEmptyOrFalse(data)) {
                                                                                chatList = snapshot.data!.docs.map((element) => ((ChatDataModel.fromJson(element.data() as Map<String, dynamic>)))).toList().where((element1) => element1.senderId == userModel.uId).toList();

                                                                                chatList.forEach((element) {
                                                                                  if (element.rRead == false) {
                                                                                    count++;
                                                                                  }
                                                                                });
                                                                              }
                                                                              return (count > 0)
                                                                                  ? CircleAvatar(
                                                                                      backgroundColor: appTheme.primaryTheme,
                                                                                      radius: MySize.getHeight(11),
                                                                                      child: Text(
                                                                                        count.toString(),
                                                                                        style: TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontWeight: FontWeight.w500,
                                                                                          fontSize: MySize.getHeight(13),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  : SizedBox();
                                                                            } else
                                                                              return SizedBox();
                                                                          }
                                                                          return SizedBox();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox();
                                          })
                                      : Column(
                                          children: [
                                            Expanded(
                                              child: Center(
                                                child: Text("No any friends."),
                                              ),
                                            ),
                                          ],
                                        );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          });
        });
  }

  Widget userCard(
      UserModel user, MyFriendsController controller, String docId) {
    return Container(
      //height: MediaQuery.of(context).size.height*0.3,
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
      child: Card(
        elevation: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child:
                  getImageByLink(url: user.imgUrl ?? "", height: 80, width: 80),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(user.name.toString() + " " + user.lastName.toString(),
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                  !isNullEmptyOrFalse(user.address)
                      ? user.address.toString()
                      : "Remote",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400)),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text('Level ${user.level}',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                      fontWeight: FontWeight.w300)),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreamBuilder(
                  stream: getIt<FirebaseService>().getChatData(
                      chatId: getIt<FirebaseService>()
                          .getChatId(friendUid: user.uId.toString())),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      var docList = snapshot.data!.docs;
                      if (docList.isNotEmpty) {
                        ChatDataModel message = ChatDataModel.fromJson(
                            docList.first.data() as Map<String, dynamic>);
                        return Text(
                          (message.isImage ?? false)
                              ? "Image"
                              : message.msg.toString(),
                          style: TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: MySize.getHeight(12),
                            fontWeight: (message.rRead == false &&
                                    message.senderId == user.uId)
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      } else
                        return Center(
                          child: Text(
                            "No Message",
                            style: TextStyle(
                              fontSize: MySize.getHeight(12),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        );
                    }
                    return Text(
                      "Loading...",
                      style: TextStyle(
                        fontSize: MySize.getHeight(12),
                        fontWeight: FontWeight.normal,
                      ),
                    );
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: getIt<FirebaseService>().getChatData(
                      chatId: getIt<FirebaseService>()
                          .getChatId(friendUid: user.uId.toString())),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      var docList = snapshot.data!.docs;
                      int count = 0;
                      if (docList.isNotEmpty) {
                        var data = snapshot.data!.docs;
                        List<ChatDataModel> chatList = [];
                        if (!isNullEmptyOrFalse(data)) {
                          chatList = snapshot.data!.docs
                              .map((element) => ((ChatDataModel.fromJson(
                                  element.data() as Map<String, dynamic>))))
                              .toList()
                              .where(
                                  (element1) => element1.senderId == user.uId)
                              .toList();

                          chatList.forEach((element) {
                            if (element.rRead == false) {
                              count++;
                            }
                          });
                        }
                        return (count > 0)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: CircleAvatar(
                                  backgroundColor: appTheme.primaryTheme,
                                  radius: MySize.getHeight(11),
                                  child: Text(
                                    count.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: MySize.getHeight(13),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox();
                      } else
                        return SizedBox();
                    }
                    return SizedBox();
                  },
                ),
              ],
            ),
            Space.height(30),
            button(
              title: "Message",
              onTap: () async {
                Get.toNamed(Routes.CHAT_SCREEN, arguments: {
                  ArgumentConstant.userData: user,
                  ArgumentConstant.docId: docId,
                });
              },
              widget: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.white,
                  ),
                  Space.width(15),
                  Text(
                    "Message",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: MySize.getHeight(14),
                    ),
                  ),
                ],
              ),
              width: 200,
              height: 40,
              fontsize: 12,
            )
            // Padding(
            //     padding: const EdgeInsets.all(10),
            //     child: InkWell(
            //       onTap: () {
            //         showSendMessageDialog(context, user);
            //         //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SendMessageScreen(user)));
            //       },
            //       child: Container(
            //         margin: const EdgeInsets.only(left: 10, right: 10),
            //         height: 50,
            //         decoration: BoxDecoration(
            //             color: primaryColor,
            //             borderRadius: BorderRadius.circular(10)),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const Icon(
            //               Icons.chat_outlined,
            //               color: Colors.white,
            //             ),
            //             const SizedBox(
            //               width: 10,
            //             ),
            //             const Text(
            //               'Message',
            //               style: TextStyle(color: Colors.white, fontSize: 18),
            //             )
            //           ],
            //         ),
            //       ),
            //     )),
          ],
        ),
      ),
    );
  }

  getTitleWithDay(DateTime date) async {
    DateTime now = date.toUtc();
    int i = await calculateDifference(now);
    if (i == 0) {
      return DateFormat("hh:mm a").format(date.toLocal());
    } else if (i == -1) {
      return "Yesterday";
    } else {
      return DateFormat("dd/MM/yy").format(date.toLocal());
    }
  }
}
