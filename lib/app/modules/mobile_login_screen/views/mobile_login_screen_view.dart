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
      backgroundColor: appTheme.backgroungGray,
      body: Obx(() {
        return SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MySize.screenHeight,
                width: MySize.screenWidth,
                padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(30)),
                child: Column(
                  children: [
                    Spacing.height(kToolbarHeight),
                    Center(
                      child: Text(
                        "Chat App",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: MySize.getHeight(32),
                        ),
                      ),
                    ),
                    Spacing.height(70),
                    Card(
                      color: Colors.white,
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.getWidth(25),
                            vertical: MySize.getHeight(7)),
                        height: MySize.getHeight(350),
                        child: Column(
                          children: [
                            Spacing.height(50),
                            Container(
                              width: MySize.safeWidth,
                              child: getUnderLineTextBox(
                                  textController:
                                      controller.countryCodeController.value,
                                  height: 50,
                                  width: 100,
                                  fontWeight: FontWeight.bold,
                                  topPadding: MySize.getHeight(10),
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
                                                  .text =
                                              "(+${val.phoneCode}) ${val.name}";
                                          controller.countryCodeController
                                              .refresh();
                                        });
                                  }),
                            ),
                            Spacing.height(15),
                            Container(
                              width: MySize.safeWidth,
                              child: getUnderLineTextBox(
                                  textController: controller.numberController,
                                  hintText: "Enter your mobile number",
                                  textInputType: TextInputType.number,
                                  height: 50,
                                  width: 200,
                                  size: MySize.getHeight(40),
                                  topPadding: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Spacing.height(50),
                    Center(
                      child: button(
                        title: "Continue",
                        fontsize: MySize.getHeight(20),
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
                        height: MySize.getHeight(65),
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
