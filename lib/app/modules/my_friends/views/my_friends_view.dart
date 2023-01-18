import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';
import '../controllers/my_friends_controller.dart';

class MyFriendsView extends GetWidget<MyFriendsController> {
  const MyFriendsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream:
                                getIt<FirebaseService>().getAllFriendsOfUser(),
                            builder: (BuildContext context, snapshot) {
                              if (snapshot.hasError) {
                                return Expanded(
                                  child: Center(
                                    child: Text("Something went wrong..."),
                                  ),
                                );
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              } else {
                                return (snapshot.data!.docs.length > 0)
                                    ? Expanded(
                                        child: ListView.builder(
                                            padding: EdgeInsets.symmetric(
                                                vertical: MySize.getHeight(20),
                                                horizontal:
                                                    MySize.getWidth(10)),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              print(snapshot
                                                  .data!.docs[index].id);
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
                                                              Routes
                                                                  .CHAT_SCREEN,
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
                                                                        Text(
                                                                          getTitleWithDay(
                                                                            DateTime.fromMillisecondsSinceEpoch(
                                                                              userModel.timeStamp!,
                                                                            ),
                                                                          ),
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                MySize.getHeight(12),
                                                                          ),
                                                                        ),

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
                                                                          stream:
                                                                              getIt<FirebaseService>().getChatData(chatId: getIt<FirebaseService>().getChatId(friendUid: userModel.uId.toString())),
                                                                          builder:
                                                                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                            if (snapshot.hasData) {
                                                                              var docList = snapshot.data!.docs;
                                                                              int count = 0;
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
                                            }),
                                      )
                                    : Expanded(
                                        child: Center(
                                          child: Text("No any friends."),
                                        ),
                                      );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
            );
          });
        });
  }

  getTitleWithDay(DateTime date) {
    DateTime now = date.toUtc();
    int i = calculateDifference(now);
    if (i == 0) {
      return DateFormat("hh:mm a").format(date.toLocal());
    } else if (i == -1) {
      return "Yesterday";
    } else {
      return DateFormat("dd/MM/yy").format(date.toLocal());
    }
  }
}
