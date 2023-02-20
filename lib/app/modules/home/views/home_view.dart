import 'package:chat_app/app/constants/sizeConstant.dart';
import 'package:chat_app/app/modules/add_user/views/add_user_view.dart';
import 'package:chat_app/app/modules/my_friends/views/my_friends_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../model/user_model.dart';
import '../../../provider/card_provider.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/date_utilities.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  void _onItemTapped(int index) {
    final cardProvider = Provider.of<CardProvider>(Get.context!, listen: false);
    controller.selectedIndex.value = index;
    cardProvider.reset();
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Obx(() {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Add Friends',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Messages List',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: appTheme.primaryTheme,
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                await getIt<FirebaseService>()
                    .logOut(context: context)
                    .then((value) {
                  box.erase();
                  Get.offAllNamed(Routes.REGISTER);
                });
              },
              icon: Icon(Icons.logout)),
          title: Text(
            getTitleString(),
          ),
          centerTitle: true,
          actions: [
            (controller.selectedIndex.value == 1)
                ? IconButton(
                    onPressed: () async {
                      Get.toNamed(Routes.FRIEND_REQUEST);
                    },
                    icon: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Container(
                            // color: Colors.white,
                            height: 30,
                            width: 30,
                            child: Icon(Icons.people)),
                        StreamBuilder<QuerySnapshot>(
                          stream: getIt<FirebaseService>()
                              .getAllPendingRequestList(),
                          builder: (BuildContext context, snapshot) {
                            if (snapshot.hasError) {
                              return SizedBox();
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox();
                            } else {
                              return (snapshot.data!.docs.length > 0)
                                  ? Positioned(
                                      child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 3,
                                    ))
                                  : SizedBox();
                            }
                          },
                        ),
                      ],
                    ))
                : SizedBox(),
            // const Center(
            //     child: Text(
            //   'Resets In : ',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            // )),
          ],
        ),
        body: (controller.hasData.value)
            ? [
                Column(
                  children: [
                    Space.height(15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(
                            child: Text(
                          'Resets In : ',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        )),
                        if (controller.lastUpdated.value > 0)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: CountdownTimer(
                                endWidget: Container(),
                                onEnd: () {
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) async {
                                    DateTime now = await getNtpTime();
                                    controller.lastUpdated.value =
                                        now.toUtc().millisecondsSinceEpoch;
                                    await FirebaseService.changeLastUpdated(
                                        context);
                                    controller.getRandomUserList();
                                    controller.update();
                                  });
                                },
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                endTime: controller.lastUpdated.value + 600000,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Expanded(child: AddUserView()),
                  ],
                ),
                MyFriendsView(),
              ].elementAt(controller.selectedIndex.value)
            : Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }

  String getTitleString() {
    return [
      "Add Friends",
      "Friends",
    ].elementAt(controller.selectedIndex.value);
  }
}
