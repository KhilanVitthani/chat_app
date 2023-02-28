import 'package:carousel_slider/carousel_slider.dart';
import 'package:chat_app/app/Widgets/button.dart';
import 'package:chat_app/app/constants/color_constant.dart';
import 'package:chat_app/app/utilities/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../provider/UserDataProvider.dart';
import '../../../provider/card_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';
import '../controllers/add_user_controller.dart';

class AddUserView extends GetWidget<AddUserController> {
  const AddUserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserDataProvider>(context, listen: false);
    final cardProvider = Provider.of<CardProvider>(context, listen: false);
    return GetBuilder<AddUserController>(
        init: AddUserController(),
        builder: (controller) {
          return Obx(() {
            return Scaffold(
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
                          (controller.homeController.hasUserData.isTrue)
                              ? ((controller.homeController.userList.length > 0)
                                  ? Expanded(
                                      child: Column(
                                        children: [
                                          Consumer<CardProvider>(
                                            builder: (context, card, _) {
                                              print('card ${card.pageIndex}');
                                              if (cardProvider.pageIndex > 0) {
                                                return Center(
                                                    child: InkWell(
                                                  onTap: () {
                                                    controller
                                                        .carouselController
                                                        .value
                                                        .previousPage(
                                                            duration:
                                                                const Duration(
                                                                    seconds: 1),
                                                            curve: Curves
                                                                .easeInOut);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      top: 8,
                                                    ),
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          appTheme.primaryTheme,
                                                      child: Icon(
                                                        Icons.arrow_upward,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                              } else {
                                                return const CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Icon(
                                                    Icons.arrow_upward,
                                                    color: Colors.transparent,
                                                  ),
                                                );
                                              }
                                            },
                                          ),
                                          Expanded(
                                            child: CarouselSlider.builder(
                                                itemCount: controller
                                                    .homeController
                                                    .userList
                                                    .length,
                                                carouselController: controller
                                                    .carouselController.value,
                                                options: CarouselOptions(
                                                  autoPlay: false,
                                                  enlargeCenterPage: true,
                                                  viewportFraction: 0.8,
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  onPageChanged:
                                                      (int page, reason) {
                                                    cardProvider.setIndex(page);
                                                  },
                                                  enableInfiniteScroll: false,
                                                  aspectRatio: 2.0,
                                                  initialPage: 0,
                                                ),
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int itemIndex,
                                                        int pageViewIndex) {
                                                  return (controller.userData!
                                                          .friendsList!
                                                          .contains(controller
                                                              .homeController
                                                              .userList[
                                                                  itemIndex]
                                                              .uId))
                                                      ? SizedBox()
                                                      : userCard(
                                                          controller
                                                                  .homeController
                                                                  .userList[
                                                              itemIndex],
                                                          controller);
                                                }),
                                          ),
                                          Consumer<CardProvider>(
                                            builder: (context, card, _) {
                                              // print(
                                              //     'bottom ${card.pageIndex} ${snapshot.data!.docs.length - 1}');
                                              if (cardProvider.pageIndex <
                                                  controller.homeController
                                                          .userList.length -
                                                      1) {
                                                return Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                            .carouselController
                                                            .value
                                                            .nextPage(
                                                                duration:
                                                                    const Duration(
                                                                        seconds:
                                                                            1),
                                                                curve: Curves
                                                                    .easeInOut);
                                                      },
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            appTheme
                                                                .primaryTheme,
                                                        child: Icon(
                                                            Icons
                                                                .arrow_downward_outlined,
                                                            color:
                                                                Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              } else {
                                                return const Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: Icon(
                                                      Icons
                                                          .arrow_downward_outlined,
                                                      color: Colors.transparent,
                                                    ),
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Center(
                                      child: Text("No more users"),
                                    )))
                              : Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ),
                        ],
                      ),
                    ),
            );
          });
        });
  }

  Widget userCard(UserModel user, AddUserController controller) {
    return StatefulBuilder(builder: (context, setter) {
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
                child: getImageByLink(
                    url: user.imgUrl ?? "", height: 80, width: 80),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    user.name.toString() + " " + user.lastName.toString(),
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
              if (user.uId != box.read(ArgumentConstant.userUid) &&
                  (!controller.userData!.friendsList!.contains(user.uId))) ...[
                if (!controller.userData!.requestedFriendsList!
                    .contains(user.uId.toString()))
                  button(
                    title: "Send message",
                    onTap: () async {
                      await sendMessagePop(
                        context: context,
                        TitleName: user.name.toString() +
                            " " +
                            user.lastName.toString(),
                        user: user,
                        controller: controller,
                      );
                      setter(() {});
                    },
                    width: 200,
                    height: 40,
                    fontsize: 12,
                  )
                else
                  button(
                    title: "Requested",
                    onTap: () {},
                    fontsize: 12,
                    borderColor: appTheme.primaryTheme,
                    backgroundColor: Colors.transparent,
                    textColor: appTheme.primaryTheme,
                    width: 200,
                    height: 40,
                  ),
              ],
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
    });
  }

  sendMessagePop(
      {required BuildContext context,
      required TitleName,
      required UserModel user,
      required controller}) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Send message to" + " " + TitleName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: MySize.getHeight(30),
                  ),
                  TextFormField(
                    controller: controller.messageController.value,
                    decoration: InputDecoration(
                      hintText: "Enter message here...",
                      fillColor: Colors.white,
                      filled: true,
                      hintStyle: TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12) //<-- SEE HERE
                          ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(12) //<-- SEE HERE
                          ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      DateTime now = await getNtpTime();
                      if (!isNullEmptyOrFalse(
                          controller.messageController.value.text.trim())) {
                        controller.userData!.requestedFriendsList!
                            .add(user.uId.toString());
                        await getIt<FirebaseService>().addFriend(
                          context: Get.context!,
                          friendsModel: controller.userData!,
                          myFriendList:
                              controller.userData!.requestedFriendsList!,
                          friendsUid: user.uId!,
                        );
                        await controller.sendPushNotification(
                          nTitle: controller.userData!.name! +
                              " " +
                              controller.userData!.lastName.toString(),
                          nBody: controller.messageController.value.text,
                          nType: "nType",
                          nSenderId: box.read(ArgumentConstant.userUid),
                          nUserDeviceToken: user.fcmToken.toString(),
                        );
                        await getIt<FirebaseService>().addChatDataToFireStore(
                            chatId: controller.getChatId(user.uId),
                            chatData: {
                              "senderId": box.read(ArgumentConstant.userUid),
                              "receiverId": user.uId,
                              "msg": controller.messageController.value.text,
                              "dateTime": now.toUtc().millisecondsSinceEpoch,
                              "rRead": false,
                              "sRead": true,
                            });
                        Get.back();
                        controller.messageController.value.clear();
                      }
                      // user.fc
                    },
                    child: Container(
                      height: MySize.getHeight(50),
                      width: MySize.getWidth(130),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                          child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: MySize.getHeight(15)),
                      )),
                    ),
                  ),
                ],
              ));
        });
  }
}
