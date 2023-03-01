import 'package:chat_app/app/Widgets/button.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../main.dart';
import '../../../constants/sizeConstant.dart';
import '../../../utilities/progress_dialog_utils.dart';
import '../controllers/otp_screen_controller.dart';

class OtpScreenView extends GetView<OtpScreenController> {
  const OtpScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MySize.screenHeight,
              width: MySize.screenWidth,
              padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(20)),
              child: Column(
                children: [
                  Spacing.height(kToolbarHeight),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: MySize.getHeight(38),
                            width: MySize.getWidth(38),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.keyboard_arrow_left_outlined,
                              color: Colors.white,
                              size: MySize.getHeight(30),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!controller.showResendOtp.value)
                            Text(
                              '${controller.minute.value}:${controller.sec.value}',
                              style: TextStyle(
                                fontSize: MySize.getHeight(16),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          InkWell(
                            onTap: () {
                              if (controller.showResendOtp.value) {
                                // controller.callApiForSendOtp(
                                //     context: context);
                                controller.reSendOtp(context);
                                controller.startTimer();
                                controller.myDuration = Duration(minutes: 1);
                                controller.showResendOtp.value = false;
                              }
                            },
                            child: Text(
                              " Resend",
                              style: TextStyle(
                                fontSize: MySize.getHeight(16),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Spacing.height(20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "My code is",
                      style: TextStyle(
                          fontSize: MySize.getHeight(20),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  Spacing.height(10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      controller.mobileNo,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Spacing.height(100),
                  Container(
                    child: Pinput(
                      controller: controller.otpController,
                      length: 6,
                      pinAnimationType: PinAnimationType.slide,
                      defaultPinTheme: controller.defaultPinTheme,
                      showCursor: true,
                      cursor: controller.cursor,
                      focusNode: controller.focusNode,
                      preFilledWidget: controller.preFilledWidget,
                    ),
                  ),
                  Spacing.height(70),
                  button(
                    title: "NEXT",
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
                    height: MySize.getHeight(50),
                    width: MySize.getWidth(300),
                  ),
                ],
              ),
            ),
          ],
        )),
      );
    });
  }
}
