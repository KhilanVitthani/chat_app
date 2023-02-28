import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../Widgets/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/chat_data_model.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../controllers/friend_request_controller.dart';

class FriendRequestView extends GetWidget<FriendRequestController> {
  const FriendRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Friend Requests'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back_outlined),
              onPressed: () {
                if (controller.isFromNotification) {
                  Get.offAllNamed(Routes.HOME);
                } else {
                  Get.back();
                }
              }),
        ),
        body: (controller.hasData.isFalse)
            ? Container(
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Container(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          getIt<FirebaseService>().getAllPendingRequestList(),
                      builder: (BuildContext context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text("Something went wrong..."),
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
                                          horizontal: MySize.getWidth(10)),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        UserModel userModel =
                                            UserModel.fromJson(snapshot
                                                    .data!.docs[index]
                                                    .data()
                                                as Map<String, dynamic>);
                                        return (userModel.uId !=
                                                box.read(
                                                    ArgumentConstant.userUid))
                                            ? Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            MySize.getHeight(
                                                                10))),
                                                child: InkWell(
                                                  onTap: () async {
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: MySize
                                                                .getHeight(15),
                                                            vertical:
                                                                MySize.getWidth(
                                                                    20)),
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
                                                              Text(userModel
                                                                      .name
                                                                      .toString() +
                                                                  " " +
                                                                  userModel
                                                                      .lastName
                                                                      .toString()),
                                                              // Spacing.height(10),
                                                              // Text(userModel.uId.toString()),
                                                              Spacing.height(
                                                                  10),
                                                              StreamBuilder(
                                                                stream: getIt<
                                                                        FirebaseService>()
                                                                    .getChatData(
                                                                        chatId: getIt<FirebaseService>().getChatId(
                                                                            friendUid:
                                                                                userModel.uId.toString())),
                                                                builder: (context,
                                                                    AsyncSnapshot<
                                                                            QuerySnapshot>
                                                                        snapshot) {
                                                                  if (snapshot
                                                                      .hasData) {
                                                                    var docList =
                                                                        snapshot
                                                                            .data!
                                                                            .docs;
                                                                    if (docList
                                                                        .isNotEmpty) {
                                                                      ChatDataModel
                                                                          message =
                                                                          ChatDataModel.fromJson(docList.first.data() as Map<
                                                                              String,
                                                                              dynamic>);
                                                                      return Text(
                                                                        (message.isImage ??
                                                                                false)
                                                                            ? "Image"
                                                                            : message.msg.toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          fontSize:
                                                                              MySize.getHeight(12),
                                                                          fontWeight: (message.rRead == false && message.senderId == userModel.uId)
                                                                              ? FontWeight.bold
                                                                              : FontWeight.normal,
                                                                        ),
                                                                      );
                                                                    } else
                                                                      return Center(
                                                                        child:
                                                                            Text(
                                                                          "No Message",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                MySize.getHeight(12),
                                                                            fontWeight:
                                                                                FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      );
                                                                  }
                                                                  return Text(
                                                                    "Loading...",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          MySize.getHeight(
                                                                              12),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Space.width(20),
                                                        InkWell(
                                                          onTap: () async {
                                                            userModel
                                                                .requestedFriendsList!
                                                                .remove(userModel
                                                                    .uId
                                                                    .toString());
                                                            userModel
                                                                .friendsList!
                                                                .add(controller
                                                                    .userData!
                                                                    .uId
                                                                    .toString());
                                                            controller.userData
                                                                ?.friendsList!
                                                                .add(userModel
                                                                    .uId
                                                                    .toString());
                                                            await getIt<
                                                                    FirebaseService>()
                                                                .acceptRequest(
                                                              context: context,
                                                              userModel:
                                                                  controller
                                                                      .userData!,
                                                              myUpdatedFriendList:
                                                                  controller
                                                                          .userData
                                                                          ?.friendsList ??
                                                                      [],
                                                              docId: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              friendsModel:
                                                                  userModel,
                                                              myFriendsRequestedList:
                                                                  controller
                                                                      .userData!
                                                                      .requestedFriendsList!,
                                                              friendsUid:
                                                                  userModel
                                                                      .uId!,
                                                            );
                                                          },
                                                          child: Container(
                                                              height: MySize
                                                                  .getHeight(
                                                                      40),
                                                              width: MySize
                                                                  .getHeight(
                                                                      40),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                border:
                                                                    Border.all(
                                                                  color: appTheme
                                                                      .primaryTheme,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.check,
                                                                size: 20,
                                                                color: appTheme
                                                                    .primaryTheme,
                                                              )),
                                                        ),
                                                        Space.width(15),
                                                        InkWell(
                                                          onTap: () async {
                                                            userModel
                                                                .requestedFriendsList!
                                                                .remove(controller
                                                                    .userData!
                                                                    .uId
                                                                    .toString());

                                                            await getIt<
                                                                    FirebaseService>()
                                                                .rejectFriendRequest(
                                                              context: context,
                                                              myFriendsRequestedList:
                                                                  userModel
                                                                          .requestedFriendsList ??
                                                                      [],
                                                              docId: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id,
                                                              friendsModel:
                                                                  userModel,
                                                              friendsUid:
                                                                  userModel
                                                                      .uId!,
                                                            );
                                                          },
                                                          child: Container(
                                                              height: MySize
                                                                  .getHeight(
                                                                      40),
                                                              width: MySize
                                                                  .getHeight(
                                                                      40),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            100),
                                                                border:
                                                                    Border.all(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                              child: Icon(
                                                                Icons.close,
                                                                size: 20,
                                                                color:
                                                                    Colors.red,
                                                              )),
                                                        ),
                                                        // button(
                                                        //   title: "Accept",
                                                        //   onTap: () async {
                                                        //     userModel
                                                        //         .requestedFriendsList!
                                                        //         .remove(userModel
                                                        //             .uId
                                                        //             .toString());
                                                        //     userModel
                                                        //         .friendsList!
                                                        //         .add(controller
                                                        //             .userData!
                                                        //             .uId
                                                        //             .toString());
                                                        //     controller.userData
                                                        //         ?.friendsList!
                                                        //         .add(userModel
                                                        //             .uId
                                                        //             .toString());
                                                        //     await getIt<
                                                        //             FirebaseService>()
                                                        //         .acceptRequest(
                                                        //       context: context,
                                                        //       myUpdatedFriendList:
                                                        //           controller
                                                        //                   .userData
                                                        //                   ?.friendsList ??
                                                        //               [],
                                                        //       docId: snapshot
                                                        //           .data!
                                                        //           .docs[index]
                                                        //           .id,
                                                        //       friendsModel:
                                                        //           userModel,
                                                        //       myFriendsRequestedList:
                                                        //           controller
                                                        //               .userData!
                                                        //               .requestedFriendsList!,
                                                        //       friendsUid:
                                                        //           userModel
                                                        //               .uId!,
                                                        //     );
                                                        //   },
                                                        //   width: 60,
                                                        //   height: 30,
                                                        // )
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
                                    child: Text("No any request pending"),
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
  }
}
