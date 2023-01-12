import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
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
                                                                      .getHeight(
                                                                          15),
                                                                  vertical: MySize
                                                                      .getWidth(
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
                                                                    Spacing
                                                                        .height(
                                                                            10),
                                                                    Text(userModel
                                                                        .email
                                                                        .toString()),
                                                                  ],
                                                                ),
                                                              ),
                                                              Space.width(20),
                                                              InkWell(
                                                                child: Icon(
                                                                  Icons.chat,
                                                                  color: appTheme
                                                                      .primaryTheme,
                                                                  size: MySize
                                                                      .getHeight(
                                                                          20),
                                                                ),
                                                                onTap: () {
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .TEMP_CHAT,
                                                                      arguments: {
                                                                        ArgumentConstant.userData:
                                                                            userModel,
                                                                      });
                                                                },
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
}
