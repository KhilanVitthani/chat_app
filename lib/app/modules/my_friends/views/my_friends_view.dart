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
                                      ? Column(
                                          children: [
                                            Consumer<CardProvider>(
                                              builder: (context, card, _) {
                                                print('card ${card.pageIndex}');
                                                if (cardProvider.pageIndex >
                                                    0) {
                                                  return Center(
                                                      child: InkWell(
                                                    onTap: () {
                                                      controller
                                                          .carouselController
                                                          .value
                                                          .previousPage(
                                                              duration:
                                                                  const Duration(
                                                                      seconds:
                                                                          1),
                                                              curve: Curves
                                                                  .easeInOut);
                                                    },
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                        top: 8,
                                                      ),
                                                      child: CircleAvatar(
                                                        backgroundColor:
                                                            appTheme
                                                                .primaryTheme,
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
                                                  itemCount: snapshot
                                                      .data!.docs.length,
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
                                                      cardProvider
                                                          .setIndex(page);
                                                    },
                                                    enableInfiniteScroll: false,
                                                    aspectRatio: 2.0,
                                                    initialPage: 0,
                                                  ),
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int itemIndex,
                                                          int pageViewIndex) {
                                                    return userCard(
                                                        UserModel.fromJson(snapshot
                                                                .data!
                                                                .docs[itemIndex]
                                                                .data()
                                                            as Map<String,
                                                                dynamic>),
                                                        controller,
                                                        snapshot
                                                            .data!
                                                            .docs[itemIndex]
                                                            .id);
                                                  }),
                                            ),
                                            Consumer<CardProvider>(
                                              builder: (context, card, _) {
                                                print(
                                                    'bottom ${card.pageIndex} ${snapshot.data!.docs.length - 1}');
                                                if (cardProvider.pageIndex <
                                                    snapshot.data!.docs.length -
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
                                                        color:
                                                            Colors.transparent,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        )
                                      : Expanded(
                                          child: Center(
                                            child: Text("No any friends."),
                                          ),
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
            if (!isNullEmptyOrFalse(user.address))
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(user.address.toString(),
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
}
