import 'package:chat_app/app/Widgets/button.dart';
import 'package:chat_app/app/constants/color_constant.dart';
import 'package:chat_app/app/constants/sizeConstant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../Widgets/text_field.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetWidget<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Log In'),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: MySize.getHeight(15),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey.value,
                child: Column(
                  children: [
                    Space.height(50),
                    commonTextField(
                      fillColor: false,
                      tcPadding: 15,
                      maxLines: 1,
                      controller: controller.emailController.value,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },
                      hintText: "Enter your email id",
                      fbColor: appTheme.borderGrayColor,
                      hintTextBold: false,
                      borderRadius: MySize.getHeight(10),
                    ),
                    Space.height(30),
                    commonTextField(
                      fillColor: false,
                      obscureText: controller.isHidden.value,
                      tcPadding: 15,
                      maxLines: 1,
                      controller: controller.passwordController.value,
                      validation: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      },
                      hintText: "Enter your password",
                      fbColor: appTheme.borderGrayColor,
                      hintTextBold: false,
                      iconButton: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            controller.isHidden.toggle();
                          },
                          child: Icon(
                            controller.isHidden.isTrue
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      borderRadius: MySize.getHeight(10),
                    ),
                    Space.height(60),
                    button(
                        title: "Login",
                        fontsize: 20,
                        onTap: () {
                          if (controller.formKey.value.currentState!
                              .validate()) {
                            FocusScope.of(context).unfocus();
                            getIt<FirebaseService>()
                                .logInUserInFirebase(
                                    context: context,
                                    userModel: UserModel(
                                        requestedFriendsList: [],
                                        uId: "",
                                        level: 1,
                                        lastName: "",
                                        name: "",
                                        imgUrl: '',
                                        email: controller
                                            .emailController.value.text,
                                        password: controller
                                            .passwordController.value.text,
                                        friendsList: [],
                                        chatStatus: false))
                                .then((value) {
                              if (!isNullEmptyOrFalse(value)) {
                                Get.offAllNamed(Routes.HOME);
                              }
                            });
                          }
                        }),
                    Space.height(20),
                    Row(
                      children: <Widget>[
                        const Text('Does not have account?'),
                        TextButton(
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Get.toNamed(Routes.SIGN_UP);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
