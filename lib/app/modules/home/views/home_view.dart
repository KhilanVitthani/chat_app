import 'package:chat_app/app/constants/sizeConstant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('HomeView'),
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
                    Get.offAllNamed(Routes.LOGIN);
                  });
                },
                icon: Icon(Icons.logout)),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: "tag001",
          onPressed: () {
            // if (!isNullEmptyOrFalse(controller.userData)) {
            //   Get.toNamed(Routes.ADD_USER, arguments: {
            //     ArgumentConstant.userData: controller.userData,
            //   });
            // }
            Get.toNamed(Routes.CHAT_SCREEN);
          },
          child: Icon(Icons.add),
        ),
        body: (controller.hasData.isFalse)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Text(
                  'HomeView is working',
                  style: TextStyle(fontSize: 20),
                ),
              ),
      );
    });
  }
}
