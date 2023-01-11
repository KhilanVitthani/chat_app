import 'package:chat_app/app/Widgets/button.dart';
import 'package:chat_app/app/constants/color_constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../service/firebase_service.dart';
import '../controllers/add_user_controller.dart';

class AddUserView extends GetWidget<AddUserController> {
  const AddUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Add Friends'),
          centerTitle: true,
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
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
                      stream: getIt<FirebaseService>().getAllUsersList(),
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
                          return Expanded(
                            child: ListView.builder(
                                padding: EdgeInsets.symmetric(
                                    vertical: MySize.getHeight(20),
                                    horizontal: MySize.getWidth(10)),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  UserModel userModel = UserModel.fromJson(
                                      snapshot.data!.docs[index].data()
                                          as Map<String, dynamic>);
                                  return (userModel.uId !=
                                              box.read(
                                                  ArgumentConstant.userUid) &&
                                          (!controller.userData!.friendsList!
                                              .contains(userModel.uId)))
                                      ? Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      MySize.getHeight(10))),
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MySize.getHeight(15),
                                                  vertical:
                                                      MySize.getWidth(20)),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200),
                                                    child: getImageByLink(
                                                        url: userModel.imgUrl ??
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
                                                        Text(userModel.name
                                                                .toString() +
                                                            " " +
                                                            userModel.lastName
                                                                .toString()),
                                                        // Spacing.height(10),
                                                        // Text(userModel.uId.toString()),
                                                        Spacing.height(10),
                                                        Text(userModel.email
                                                            .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                  Space.width(20),
                                                  if (!controller.userData!
                                                      .requestedFriendsList!
                                                      .contains(userModel.uId
                                                          .toString()))
                                                    button(
                                                      title: "Follow",
                                                      onTap: () async {
                                                        controller.userData!
                                                            .requestedFriendsList!
                                                            .add(userModel.uId
                                                                .toString());
                                                        await getIt<
                                                                FirebaseService>()
                                                            .addFriend(
                                                          context: context,
                                                          friendsModel:
                                                              controller
                                                                  .userData!,
                                                          myFriendList: controller
                                                              .userData!
                                                              .requestedFriendsList!,
                                                          friendsUid:
                                                              userModel.uId!,
                                                        );
                                                      },
                                                      width: 60,
                                                      height: 30,
                                                    )
                                                  else
                                                    button(
                                                      title: "Requested",
                                                      onTap: () {},
                                                      borderColor:
                                                          appTheme.primaryTheme,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      textColor:
                                                          appTheme.primaryTheme,
                                                      width: 80,
                                                      height: 30,
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      : SizedBox();
                                }),
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
