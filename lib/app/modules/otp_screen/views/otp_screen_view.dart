import 'package:chat_app/app/Widgets/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:pinput/pinput.dart';

import '../../../../main.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../utilities/progress_dialog_utils.dart';
import '../controllers/otp_screen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  const OtpScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: KeyboardActions(
          config: controller.buildConfig(context),
          child: SingleChildScrollView(
              child: Container(
            height: MySize.screenHeight,
            width: MySize.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(20)),
            child: Column(
              children: [
                Spacing.height(kToolbarHeight),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     Align(
                //       alignment: Alignment.centerLeft,
                //       child: InkWell(
                //         onTap: () {
                //           Get.back();
                //         },
                //         child: Container(
                //           height: MySize.getHeight(38),
                //           width: MySize.getWidth(38),
                //           decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //           ),
                //           alignment: Alignment.center,
                //           child: Icon(
                //             Icons.keyboard_arrow_left_outlined,
                //             color: Colors.white,
                //             size: MySize.getHeight(30),
                //           ),
                //         ),
                //       ),
                //     ),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         if (!controller.showResendOtp.value)
                //           Text(
                //             '${controller.minute.value}:${controller.sec.value}',
                //             style: TextStyle(
                //               fontSize: MySize.getHeight(16),
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         InkWell(
                //           onTap: () {
                //             if (controller.showResendOtp.value) {
                //               // controller.callApiForSendOtp(
                //               //     context: context);
                //               controller.reSendOtp(context);
                //               controller.startTimer();
                //               controller.myDuration = Duration(minutes: 1);
                //               controller.showResendOtp.value = false;
                //             }
                //           },
                //           child: Text(
                //             " Resend",
                //             style: TextStyle(
                //               fontSize: MySize.getHeight(16),
                //               fontWeight: FontWeight.w400,
                //             ),
                //           ),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
                Spacing.height(20),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "OTP",
                    style: TextStyle(
                        fontSize: MySize.getHeight(25),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Spacing.height(50),
                Container(
                  child: Pinput(
                    controller: controller.otpController,
                    length: 6,
                    // pinAnimationType: PinAnimationType.slide,
                    defaultPinTheme: PinTheme(
                      width: MySize.getHeight(50),
                      height: MySize.getHeight(75),
                      textStyle: TextStyle(
                        fontSize: MySize.getHeight(35),
                        color: Colors.black,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.06),
                            blurStyle: BlurStyle.outer,
                            blurRadius: MySize.getHeight(13),
                            spreadRadius: MySize.getHeight(1),
                          ),
                        ],
                      ),
                    ),
                    showCursor: true,
                    cursor: controller.cursor,
                    focusNode: controller.focusNode,
                    // preFilledWidget: controller.preFilledWidget,
                  ),
                ),
                Spacing.height(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!controller.showResendOtp.value)
                      Text(
                        '${controller.minute.value}:${controller.sec.value}',
                        style: TextStyle(
                          fontSize: MySize.getHeight(16),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    if (controller.showResendOtp.value)
                      Text.rich(
                        TextSpan(children: [
                          TextSpan(
                              text: "Don't get a code?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MySize.getHeight(15))),
                          TextSpan(
                              text: "Request one again",
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  if (controller.showResendOtp.value) {
                                    // controller.callApiForSendOtp(
                                    //     context: context);
                                    controller.reSendOtp(context);
                                    controller.startTimer();
                                    controller.myDuration =
                                        Duration(minutes: 1);
                                    controller.showResendOtp.value = false;
                                  }
                                },
                              style: TextStyle(
                                  color: appTheme.primaryTheme,
                                  fontWeight: FontWeight.bold,
                                  fontSize: MySize.getHeight(15))),
                        ]),
                      ),
                  ],
                ),
                Spacer(),
                button(
                  title: "Continue",
                  fontsize: MySize.getHeight(20),
                  onTap: () {
                    if (!isNullEmptyOrFalse(controller.otpController.text) &&
                        controller.otpController.text.trim().length == 6) {
                      // Get.toNamed(Routes.ASK_EMAIL_SCREEN);
                      controller.verifyOtp(context);
                    } else {
                      getIt<CustomDialogs>()
                          .getDialog(title: "Error", desc: "Invalid OTP");
                    }
                  },
                  height: MySize.getHeight(65),
                  width: MySize.getWidth(300),
                ),
                Spacing.height(100)
              ],
            ),
          )),
        ),
      );
    });
  }
}
