import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

import '../../../../main.dart';
import '../../../Widgets/button.dart';
import '../../../Widgets/dropdown_textfiled.dart';
import '../../../Widgets/text_field.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/progress_dialog_utils.dart';
import '../controllers/sign_up_controller.dart';

class SignUpView extends GetWidget<SignUpController> {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
        leading: SizedBox(),
      ),
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.only(left: 23.0, right: 24, bottom: 10.0, top: 10)
                .copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
        ),
        child: button(
            title: "Sign Up",
            fontsize: 20,
            onTap: () async {
              if (controller.formKey.value.currentState!.validate()) {
                FocusScope.of(context).unfocus();

                String imgUrl = "";
                if (controller.profile != null) {
                  getIt<CustomDialogs>().showCircularDialog(context);
                  getIt<FirebaseService>()
                      .uplordImage(controller.profile!.value)
                      .then((value) {
                    getIt<CustomDialogs>().hideCircularDialog(context);
                    if (value != null) {
                      imgUrl = value;
                    }
                    getIt<FirebaseService>()
                        .registerUserInFirebase(
                            context: context,
                            userModel: UserModel(
                                uId: "",
                                requestedFriendsList: [],
                                imgUrl: imgUrl,
                                level: controller.selectUserLevelType.value
                                    .dropDownValue!.value,
                                name: controller.firstNameController.value.text,
                                lastName:
                                    controller.secondNameController.value.text,
                                email: controller.emailController.value.text,
                                password: controller
                                    .confirmPasswordController.value.text,
                                friendsList: [],
                                chatStatus: false))
                        .then((value) {
                      if (!isNullEmptyOrFalse(value)) {
                        Get.offAllNamed(Routes.HOME);
                      }
                    });
                  });
                }
              }
            }),
      ),
      body: Obx(() {
        return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);

            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MySize.getHeight(15),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.formKey.value,
                    child: Column(
                      children: [
                        Space.height(30),
                        getImageView(),
                        Space.height(20),
                        commonTextField(
                          fillColor: false,
                          tcPadding: 15,
                          maxLines: 1,
                          controller: controller.firstNameController.value,
                          validation: (value) {
                            RegExp regex = new RegExp(r'^.{3,}$');
                            if (value!.isEmpty) {
                              return ("First Name cannot be Empty");
                            }
                            if (!regex.hasMatch(value)) {
                              return ("Enter Valid name(Min. 3 Character)");
                            }
                            return null;
                          },
                          hintText: "Enter First Name",
                          fbColor: appTheme.borderGrayColor,
                          hintTextBold: false,
                          borderRadius: MySize.getHeight(10),
                        ),
                        Space.height(20),
                        commonTextField(
                          fillColor: false,
                          tcPadding: 15,
                          maxLines: 1,
                          controller: controller.secondNameController.value,
                          validation: (value) {
                            if (value!.isEmpty) {
                              return ("Last Name cannot be Empty");
                            }
                            return null;
                          },
                          hintText: "Enter Last Name",
                          fbColor: appTheme.borderGrayColor,
                          hintTextBold: false,
                          borderRadius: MySize.getHeight(10),
                        ),
                        Space.height(20),
                        getDropDownTextField(
                          controller: controller.selectUserLevelType.value,
                          tcPadding: 15,
                          validation: (value) {
                            if (value!.isEmpty) {
                              return ("Please select user level.");
                            }
                            return null;
                          },
                          hintText: "Select user level",
                          list: [
                            DropDownValueModel(name: 'Level 1', value: 1),
                            DropDownValueModel(
                              name: 'Level 2',
                              value: 2,
                            ),
                            DropDownValueModel(
                              name: 'Level 3',
                              value: 3,
                            ),
                          ],
                        ),
                        Space.height(20),
                        commonTextField(
                          fillColor: false,
                          tcPadding: 15,
                          maxLines: 1,
                          controller: controller.emailController.value,
                          validation: (value) {
                            if (value!.isEmpty) {
                              return ("Please Enter Your Email");
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return ("Please Enter a valid email");
                            }
                            return null;
                          },
                          hintText: "Enter email id",
                          fbColor: appTheme.borderGrayColor,
                          hintTextBold: false,
                          borderRadius: MySize.getHeight(10),
                        ),
                        Space.height(20),
                        commonTextField(
                          fillColor: false,
                          obscureText: controller.isHidden.value,
                          tcPadding: 15,
                          maxLines: 1,
                          controller: controller.passwordController.value,
                          validation: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required.");
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
                        Space.height(20),
                        commonTextField(
                          fillColor: false,
                          obscureText: controller.isHiddenConfirm.value,
                          tcPadding: 15,
                          maxLines: 1,
                          controller:
                              controller.confirmPasswordController.value,
                          validation: (value) {
                            RegExp regex = new RegExp(r'^.{6,}$');
                            if (value!.isEmpty) {
                              return ("Password is required.");
                            } else if (!regex.hasMatch(value)) {
                              return ("Enter Valid Password(Min. 6 Character)");
                            } else if (value !=
                                controller.passwordController.value.text) {
                              return ('Both Password are not match');
                            }
                          },
                          hintText: "Re-Enter password",
                          fbColor: appTheme.borderGrayColor,
                          hintTextBold: false,
                          iconButton: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                controller.isHiddenConfirm.toggle();
                              },
                              child: Icon(
                                controller.isHiddenConfirm.isTrue
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          borderRadius: MySize.getHeight(10),
                        ),
                        // Space.height(60),

                        Space.height(20),
                        // Row(
                        //   children: <Widget>[
                        //     const Text('Does not have account?'),
                        //     TextButton(
                        //       child: const Text(
                        //         'Sign up',
                        //         style: TextStyle(fontSize: 20),
                        //       ),
                        //       onPressed: () {
                        //         Get.toNamed(Routes.SIGN_UP);
                        //       },
                        //     )
                        //   ],
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Padding(
              //     padding: const EdgeInsets.only(
              //             left: 23.0, right: 24, bottom: 10.0, top: 10)
              //         .copyWith(
              //       bottom: MediaQuery.of(context).viewInsets.bottom,
              //     ),
              //     child: button(
              //         title: "Sign Up",
              //         fontsize: 20,
              //         onTap: () async {
              //           if (controller.formKey.value.currentState!.validate()) {
              //             FocusScope.of(context).unfocus();
              //
              //             String imgUrl = "";
              //             if (controller.profile != null) {
              //               getIt<CustomDialogs>().showCircularDialog(context);
              //               imgUrl = await getIt<FirebaseService>()
              //                   .uplordImage(controller.profile!.value);
              //               getIt<CustomDialogs>().hideCircularDialog(context);
              //             }
              //             getIt<FirebaseService>()
              //                 .logInUserInFirebase(
              //                     context: context,
              //                     userModel: UserModel(
              //                         uId: "",
              //                         imgUrl: imgUrl,
              //                         name: "",
              //                         email:
              //                             controller.emailController.value.text,
              //                         password: controller
              //                             .passwordController.value.text,
              //                         friendsList: [],
              //                         chatStatus: false))
              //                 .then((value) {
              //               if (!isNullEmptyOrFalse(value)) {
              //                 Get.offAllNamed(Routes.HOME);
              //               }
              //             });
              //           }
              //         }),
              //   ),
              // ),
            ],
          ),
        );
      }),
    );
  }

  Widget getImageView() {
    return Obx(() => Center(
          child: InkWell(
            onTap: () async {
              FocusScope.of(Get.context!).unfocus();
              Get.dialog(Dialog(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () async {
                          controller.openCamera().then((value) {
                            controller.cropImage(
                              pickedFile: value,
                              context: Get.context!,
                            );
                          }).catchError((error) {
                            print(error);
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                                height: 60,
                                child: Icon(
                                  Icons.camera,
                                  color: appTheme.primaryTheme,
                                  size: 60,
                                )),
                            Space.height(10),
                            Text(
                              "Camera",
                              style: TextStyle(
                                color: appTheme.primaryTheme,
                                fontWeight: FontWeight.bold,
                                fontSize: MySize.getHeight(18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 40,
                      ),
                      InkWell(
                        onTap: () async {
                          controller.openGallery().then((value) {
                            controller.cropImage(
                              pickedFile: value,
                              context: Get.context!,
                            );
                          }).catchError((error) {
                            print(error);
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 60,
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: appTheme.primaryTheme,

                                //color: AppColors.kOrange,
                                size: 60,
                              ),
                            ),
                            Space.height(10),
                            Text(
                              "Gallery",
                              style: TextStyle(
                                color: appTheme.primaryTheme,
                                fontWeight: FontWeight.bold,
                                fontSize: MySize.getHeight(18),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            },
            child: Container(
              width: MySize.getHeight(100),
              height: MySize.getHeight(100),
              decoration: BoxDecoration(
                border: Border.all(
                  color: appTheme.primaryTheme,
                ),
                borderRadius: BorderRadius.circular(
                  MySize.getHeight(200),
                ),
                color: Colors.white,
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    MySize.getHeight(200),
                  ),
                  child: (controller.count.value >= 0 &&
                          controller.profile != null)
                      ? Image.file(controller.profile!.value!,
                          width: MySize.getHeight(120),
                          height: MySize.getHeight(120),
                          fit: BoxFit.cover)
                      : Center(
                          // child: SvgPicture.asset(
                          //   "assets/ic_plus.svg",
                          // ),
                          child: Icon(
                            Icons.add,
                            size: MySize.getHeight(20),
                          ),
                        ),
                ),
              ),
            ),
          ),
        ));
  }
}
