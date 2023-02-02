import 'package:chat_app/app/constants/sizeConstant.dart';
import 'package:chat_app/app/modules/add_user/views/add_user_view.dart';
import 'package:chat_app/app/modules/my_friends/views/my_friends_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  void _onItemTapped(int index) {
    controller.selectedIndex.value = index;
  }

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Obx(() {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Messages List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_add),
              label: 'Add Friends',
            ),
          ],
          currentIndex: controller.selectedIndex.value,
          selectedItemColor: appTheme.primaryTheme,
          onTap: _onItemTapped,
        ),
        appBar: AppBar(
          title: Text(
            getTitleString(),
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () async {
                  Get.toNamed(Routes.FRIEND_REQUEST);
                },
                icon: Icon(Icons.people)),
            IconButton(
                onPressed: () async {
                  await getIt<FirebaseService>()
                      .logOut(context: context)
                      .then((value) {
                    box.erase();
                    Get.offAllNamed(Routes.REGISTER);
                  });
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        body: [
          MyFriendsView(),
          AddUserView(),
        ].elementAt(controller.selectedIndex.value),
      );
    });
  }

  String getTitleString() {
    return ["Friends", "Add Friends"].elementAt(controller.selectedIndex.value);
  }
}
