import 'package:chat_app/app/Widgets/button.dart';
import 'package:chat_app/app/utilities/text_field.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../utilities/progress_dialog_utils.dart';
import '../controllers/mobile_login_screen_controller.dart';

class MobileLoginScreenView extends GetView<MobileLoginScreenController> {
  const MobileLoginScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);

    return Scaffold(
      body: Obx(() {
        return SingleChildScrollView(
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
                    Spacing.height(20),
                    Center(
                      child: Text(
                        "Chat App",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MySize.getHeight(32),
                        ),
                      ),
                    ),
                    Spacing.height(100),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "My number is",
                        style: TextStyle(
                            fontSize: MySize.getHeight(20),
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Spacing.height(20),
                    Row(
                      children: [
                        Container(
                          child: getUnderLineTextBox(
                              textController:
                                  controller.countryCodeController.value,
                              height: 40,
                              width: 100,
                              leftPadding: MySize.getWidth(15),
                              size: MySize.getHeight(0),
                              readOnly: true,
                              suffix: Icon(
                                Icons.arrow_drop_down,
                                color: appTheme.primaryTheme,
                                size: MySize.getHeight(20),
                              ),
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    onSelect: (val) {
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                      controller.countryCodeController.value
                                          .text = "+${val.phoneCode}";
                                      controller.countryCodeController
                                          .refresh();
                                    });
                              }),
                        ),
                        Spacing.width(10),
                        Container(
                          child: getUnderLineTextBox(
                              textController: controller.numberController,
                              hintText: "Number",
                              textInputType: TextInputType.number,
                              height: 40,
                              width: 200,
                              size: MySize.getHeight(40),
                              topPadding: 10),
                        ),
                      ],
                    ),
                    Spacing.height(70),
                    Text(
                      "We will send a text with verification code. Message and data rates may apply.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    Spacing.height(70),
                    Center(
                      child: button(
                        title: "NEXT",
                        onTap: () {
                          if (!isNullEmptyOrFalse(
                                  controller.numberController.text) &&
                              controller.numberController.text.trim().length !=
                                  0) {
                            controller.sendOtp(context);
                          } else {
                            getIt<CustomDialogs>().getDialog(
                                title: "Error", desc: "Invalid phone number");
                          }
                        },
                        height: MySize.getHeight(50),
                        width: MySize.getWidth(300),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
