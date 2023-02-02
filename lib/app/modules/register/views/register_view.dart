import 'dart:io';

import 'package:chat_app/app/model/user_model.dart';
import 'package:chat_app/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../Widgets/button.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../service/firebase_service.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: MySize.getWidth(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Space.height(200),
            Center(
              child: Text(
                "Chat App",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MySize.getHeight(32),
                ),
              ),
            ),
            Spacer(),
            button(
                title: "Sign in with Google",
                onTap: () async {
                  controller
                      .signInWithGoogle(context: context)
                      .then((value) async {
                    if (value != null) {
                      UserModel? userData = await getIt<FirebaseService>()
                          .getUserData(context: Get.context!, uid: value.uid);
                      if (!isNullEmptyOrFalse(userData)) {
                        if (userData != null && userData.isVerified == true) {
                          Get.offAllNamed(Routes.HOME);
                          box.write(ArgumentConstant.userUid, value.uid);
                        } else {
                          await getIt<FirebaseService>()
                              .addTempUserDataToFireStore(
                                  data: {"uId": value.uid, "isVerified": false},
                                  uUid: value.uid).then((va) {
                            Get.offAllNamed(Routes.SIGN_UP, arguments: {
                              ArgumentConstant.userData: value,
                              ArgumentConstant.signInType: SignInType.google,
                            });
                          });
                        }
                      }
                    }
                  });
                }),
            Space.height(30),
            if (Platform.isIOS)
              button(
                  title: "Sign in with Apple",
                  onTap: () async {
                    controller.signInWithApple().then((value) async {
                      if (value != null) {
                        UserModel? userData = await getIt<FirebaseService>()
                            .getUserData(context: Get.context!, uid: value.uid);
                        if (!isNullEmptyOrFalse(userData)) {
                          if (userData != null && userData.isVerified == true) {
                            Get.offAllNamed(Routes.HOME);
                            box.write(ArgumentConstant.userUid, value.uid);
                          } else {
                            await getIt<FirebaseService>()
                                .addTempUserDataToFireStore(data: {
                              "uId": value.uid,
                              "isVerified": false
                            }, uUid: value.uid).then((va) {
                              Get.offAllNamed(Routes.SIGN_UP, arguments: {
                                ArgumentConstant.userData: value,
                                ArgumentConstant.signInType: SignInType.google,
                              });
                            });
                          }
                        }
                      }
                    });
                  }),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
