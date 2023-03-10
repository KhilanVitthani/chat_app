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
      // bottomNavigationBar: Obx(() {
      //   return Padding(
      //     padding: const EdgeInsets.only(
      //             left: 23.0, right: 24, bottom: 10.0, top: 10)
      //         .copyWith(
      //       bottom: MediaQuery.of(context).viewInsets.bottom + 10,
      //     ),
      //     child: (controller.n.value == 1)
      //         ? Padding(
      //             padding: EdgeInsets.only(bottom: 50),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.end,
      //               children: [
      //                 GestureDetector(
      //                   onTap: () {
      //                     if (controller.formKey1.value.currentState!
      //                         .validate()) {
      //                       controller.n.value++;
      //                     }
      //                   },
      //                   child: ClipRRect(
      //                     borderRadius: BorderRadius.circular(100),
      //                     child: Container(
      //                       color: appTheme.primaryTheme,
      //                       height: MySize.getHeight(50),
      //                       width: MySize.getHeight(50),
      //                       child: Icon(
      //                         Icons.arrow_forward_ios,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           )
      //         : (controller.n.value == 2)
      //             ? Padding(
      //                 padding: EdgeInsets.only(bottom: 50),
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     GestureDetector(
      //                       onTap: () {
      //                         controller.n.value--;
      //                       },
      //                       child: ClipRRect(
      //                         borderRadius: BorderRadius.circular(100),
      //                         child: Container(
      //                           color: appTheme.primaryTheme,
      //                           height: MySize.getHeight(50),
      //                           width: MySize.getHeight(50),
      //                           child: Icon(
      //                             Icons.arrow_back_ios_new,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                     GestureDetector(
      //                       onTap: () {
      //                         if (controller.formKey2.value.currentState!
      //                             .validate()) {
      //                           controller.n.value++;
      //                         }
      //                       },
      //                       child: ClipRRect(
      //                         borderRadius: BorderRadius.circular(100),
      //                         child: Container(
      //                           color: appTheme.primaryTheme,
      //                           height: MySize.getHeight(50),
      //                           width: MySize.getHeight(50),
      //                           child: Icon(
      //                             Icons.arrow_forward_ios,
      //                             color: Colors.white,
      //                           ),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               )
      //             : button(
      //                 title: "Sign Up",
      //                 fontsize: 20,
      //                 onTap: () async {
      //                   if (controller.formKey3.value.currentState!
      //                       .validate()) {
      //                     FocusScope.of(context).unfocus();
      //
      //                     String imgUrl = "";
      //                     if (controller.profile != null) {
      //                       getIt<CustomDialogs>().showCircularDialog(context);
      //                       getIt<FirebaseService>()
      //                           .uplordImage(controller.profile!.value)
      //                           .then((value) {
      //                         getIt<CustomDialogs>()
      //                             .hideCircularDialog(context);
      //                         if (value != null) {
      //                           imgUrl = value;
      //                         }
      //                         registerUser(imgUrl: imgUrl);
      //                       });
      //                     } else {
      //                       registerUser();
      //                     }
      //                   }
      //                 }),
      //   );
      // }),
      body: Obx(() {
        return GestureDetector(
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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Space.height(30),

                        if (controller.n.value == 1) ...[
                          Form(
                              key: controller.formKey1.value,
                              child: Column(
                                children: [
                                  getImageView(),
                                  Space.height(20),
                                  commonTextField(
                                    fillColor: false,
                                    tcPadding: 15,
                                    isNameCapital: true,
                                    maxLines: 1,
                                    controller:
                                        controller.firstNameController.value,
                                    validation: (value) {
                                      RegExp regex = new RegExp(r'^.{3,}$');
                                      if (value!.isEmpty) {
                                        return ("First name cannot be empty");
                                      }
                                      if (!regex.hasMatch(value)) {
                                        return ("Enter valid name(Min. 3 character)");
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
                                    isNameCapital: true,
                                    maxLines: 1,
                                    controller:
                                        controller.secondNameController.value,
                                    validation: (value) {
                                      if (value!.isEmpty) {
                                        return ("Last name cannot be empty");
                                      }
                                      return null;
                                    },
                                    hintText: "Enter Last Name",
                                    fbColor: appTheme.borderGrayColor,
                                    hintTextBold: false,
                                    borderRadius: MySize.getHeight(10),
                                  ),
                                  Space.height(20),
                                ],
                              ))
                        ],
                        if (controller.n.value == 2) ...[
                          Form(
                            key: controller.formKey2.value,
                            child: getDropDownTextField(
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
                          ),
                        ],
                        if (controller.n.value == 3) ...[
                          Form(
                            key: controller.formKey3.value,
                            child: commonTextField(
                              fillColor: false,
                              // obscureText: controller.isHidden.value,
                              tcPadding: 15,

                              maxLines: 1,
                              controller: controller.addressController.value,
                              readyOnly: true,
                              onPressed: () {
                                controller.setLocation();
                              },
                              validation: (value) {
                                // RegExp regex = new RegExp(r'^.{6,}$');
                                if (value!.isEmpty) {
                                  return ("Location is required.");
                                }
                                return null;
                              },
                              hintText: "Select Location",
                              fbColor: appTheme.borderGrayColor,
                              hintTextBold: false,
                              // iconButton: Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: InkWell(
                              //     onTap: () {
                              //       controller.isHidden.toggle();
                              //     },
                              //     child: Icon(
                              //       controller.isHidden.isTrue
                              //           ? Icons.visibility
                              //           : Icons.visibility_off,
                              //     ),
                              //   ),
                              // ),
                              borderRadius: MySize.getHeight(10),
                            ),
                          ),
                        ],

                        // commonTextField(
                        //   fillColor: false,
                        //   obscureText: controller.isHidden.value,
                        //   tcPadding: 15,
                        //   maxLines: 1,
                        //   controller: controller.passwordController.value,
                        //   validation: (value) {
                        //     RegExp regex = new RegExp(r'^.{6,}$');
                        //     if (value!.isEmpty) {
                        //       return ("Password is required.");
                        //     }
                        //     if (!regex.hasMatch(value)) {
                        //       return ("Enter valid password(min. 6 character)");
                        //     }
                        //   },
                        //   hintText: "Enter your password",
                        //   fbColor: appTheme.borderGrayColor,
                        //   hintTextBold: false,
                        //   iconButton: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         controller.isHidden.toggle();
                        //       },
                        //       child: Icon(
                        //         controller.isHidden.isTrue
                        //             ? Icons.visibility
                        //             : Icons.visibility_off,
                        //       ),
                        //     ),
                        //   ),
                        //   borderRadius: MySize.getHeight(10),
                        // ),
                        // Space.height(20),
                        // commonTextField(
                        //   fillColor: false,
                        //   obscureText: controller.isHiddenConfirm.value,
                        //   tcPadding: 15,
                        //   maxLines: 1,
                        //   controller: controller.confirmPasswordController.value,
                        //   validation: (value) {
                        //     RegExp regex = new RegExp(r'^.{6,}$');
                        //     if (value!.isEmpty) {
                        //       return ("Password is required.");
                        //     } else if (!regex.hasMatch(value)) {
                        //       return ("Enter valid password(min. 6 character)");
                        //     } else if (value !=
                        //         controller.passwordController.value.text) {
                        //       return ('Both Password are not match');
                        //     }
                        //   },
                        //   hintText: "Re-Enter password",
                        //   fbColor: appTheme.borderGrayColor,
                        //   hintTextBold: false,
                        //   iconButton: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: InkWell(
                        //       onTap: () {
                        //         controller.isHiddenConfirm.toggle();
                        //       },
                        //       child: Icon(
                        //         controller.isHiddenConfirm.isTrue
                        //             ? Icons.visibility
                        //             : Icons.visibility_off,
                        //       ),
                        //     ),
                        //   ),
                        //   borderRadius: MySize.getHeight(10),
                        // ),
                        // // Space.height(60),
                        //
                        // Space.height(20),
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
                Padding(
                  padding: const EdgeInsets.only(
                          left: 23.0, right: 24, bottom: 10.0, top: 10)
                      .copyWith(
                          // bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                          ),
                  child: (controller.n.value == 1)
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 50),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (controller.formKey1.value.currentState!
                                      .validate()) {
                                    controller.n.value++;
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: Container(
                                    color: appTheme.primaryTheme,
                                    height: MySize.getHeight(50),
                                    width: MySize.getHeight(50),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : (controller.n.value == 2)
                          ? Padding(
                              padding: EdgeInsets.only(bottom: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      controller.n.value--;
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        color: appTheme.primaryTheme,
                                        height: MySize.getHeight(50),
                                        width: MySize.getHeight(50),
                                        child: Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (controller
                                          .formKey2.value.currentState!
                                          .validate()) {
                                        controller.n.value++;
                                      }
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Container(
                                        color: appTheme.primaryTheme,
                                        height: MySize.getHeight(50),
                                        width: MySize.getHeight(50),
                                        child: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : button(
                              title: "Sign Up",
                              fontsize: 20,
                              onTap: () async {
                                if (controller.formKey3.value.currentState!
                                    .validate()) {
                                  FocusScope.of(context).unfocus();

                                  String imgUrl = "";
                                  if (controller.profile != null) {
                                    getIt<CustomDialogs>()
                                        .showCircularDialog(context);
                                    getIt<FirebaseService>()
                                        .uplordImage(controller.profile!.value)
                                        .then((value) {
                                      getIt<CustomDialogs>()
                                          .hideCircularDialog(context);
                                      if (value != null) {
                                        imgUrl = value;
                                      }
                                      registerUser(imgUrl: imgUrl);
                                    });
                                  } else {
                                    registerUser();
                                  }
                                }
                              }),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  registerUser({String? imgUrl}) {
    getIt<FirebaseService>()
        .registerUserInFirebase(
            context: Get.context!,
            userModel: UserModel(
                uId: controller.user!.uid,
                latLng: controller.latLng,
                timeStamp: DateTime.now().toUtc().millisecondsSinceEpoch,
                requestedFriendsList: [],
                imgUrl: imgUrl,
                level:
                    controller.selectUserLevelType.value.dropDownValue!.value,
                name: controller.firstNameController.value.text.trim(),
                lastName: controller.secondNameController.value.text.trim(),
                email: controller.emailController.value.text.trim(),
                isVerified: true,

                // password:
                //     controller.confirmPasswordController.value.text.trim(),
                friendsList: [],
                chatStatus: false))
        .then((value) {
      if (!isNullEmptyOrFalse(value)) {
        Get.offAllNamed(Routes.HOME);
      }
    });
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
