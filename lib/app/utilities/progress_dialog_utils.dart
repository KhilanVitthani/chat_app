import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_typedefs/rx_typedefs.dart';

import '../Widgets/button.dart';
import '../Widgets/titleText.dart';
import '../constants/color_constant.dart';
import '../constants/sizeConstant.dart';

class ProgressDialogUtils {
  static bool isProgressVisible = false;

  ///common method for showing progress dialog
  static void showProgressDialog({isCancellable = false}) async {
    if (!isProgressVisible) {
      Get.dialog(
        Center(
          child: CircularProgressIndicator.adaptive(
            strokeWidth: 4,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white,
            ),
          ),
        ),
        barrierDismissible: isCancellable,
      );
      isProgressVisible = true;
    }
  }

  ///common method for hiding progress dialog
  static void hideProgressDialog() {
    if (isProgressVisible) Get.back();
    isProgressVisible = false;
  }
}

class CustomDialogs {
  void showCircularDialog(BuildContext context) {
    CircularDialog.showLoadingDialog(context);
  }

  void hideCircularDialog(BuildContext context) {
    Get.back();
  }

  void showDialogPermission(
      {required BuildContext context,
      String? message,
      String? title,
      required String? confirmButtonText,
      VoidCallback? onPressed,
      bool? dismissible = true}) {
    showDialog(
      barrierDismissible: dismissible!,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: false,
          // backgroundColor: QuickHelp.isDarkMode(context)
          //     ? kContentColorLightTheme
          //     : kContentColorDarkTheme,
          elevation: 2,
          clipBehavior: Clip.hardEdge,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: SizedBox(
            width: 200,
            child: TextWithTap(
              title!,
              marginTop: 5,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
          ),
          content: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextWithTap(
                  message!,
                  textAlign: TextAlign.center,
                  // color: kSecondaryGrayColor,
                  marginBottom: 20,
                ),
                RoundedGradientButton(
                  text: confirmButtonText!,
                  //width: 150,
                  height: 48,
                  marginLeft: 30,
                  marginRight: 30,
                  marginBottom: 20,
                  borderRadius: 60,
                  textColor: Colors.white,
                  borderRadiusBottomLeft: 15,
                  colors: [
                    appTheme.primaryTheme,
                    appTheme.secondoryColor,
                  ],
                  marginTop: 0,
                  fontSize: 15,
                  onTap: () {
                    if (onPressed != null) {
                      onPressed();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  getDialog(
      {String title = "Error",
      String desc = "Some Thing went wrong....",
      Callback? onTap}) {
    return Get.defaultDialog(
        barrierDismissible: false,
        title: title,
        content: Center(
          child: Text(desc, textAlign: TextAlign.center),
        ),
        buttonColor: appTheme.primaryTheme,
        textConfirm: "Ok",
        confirmTextColor: Colors.white,
        onConfirm: (isNullEmptyOrFalse(onTap))
            ? () {
                Get.back();
              }
            : onTap);
  }
}

class CircularDialog {
  static Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            child: Center(
              child: CircularProgressIndicator(color: appTheme.primaryTheme),
            ),
            onWillPop: () async {
              return false;
            });
      },
      barrierDismissible: false,
    );
  }
}
