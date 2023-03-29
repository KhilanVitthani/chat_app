import 'package:country_codes/country_codes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../routes/app_pages.dart';
import '../../../utilities/progress_dialog_utils.dart';

class MobileLoginScreenController extends GetxController {
  TextEditingController numberController = TextEditingController();
  Rx<TextEditingController> countryCodeController = TextEditingController().obs;
  final FocusNode nodeText1 = FocusNode();
  @override
  void onInit() async {
    await CountryCodes.init();
    final CountryDetails details = CountryCodes.detailsForLocale();
    countryCodeController.value.text =
        "(${details.dialCode}) ${details.localizedName}";
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: nodeText1,
          displayDoneButton: true,
        ),
      ],
    );
  }

  sendOtp(BuildContext context) async {
    getIt<CustomDialogs>().showCircularDialog(context);
    String countryCode =
        countryCodeController.value.text.split(")")[0].split("(")[1].toString();
    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: "${countryCode}${numberController.text}",
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        getIt<CustomDialogs>().hideCircularDialog(context);
        if (e.code == 'invalid-phone-number') {
          getIt<CustomDialogs>().getDialog(
              title: "Phone Number Invalid",
              desc: "Please Check Your Phone Number.");
        } else if (e.code == "too-many-requests") {
          getIt<CustomDialogs>().getDialog(
              title: "Too many requests",
              desc:
                  "We have blocked all requests from this device due to unusual activity. Try again later.");
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        getIt<CustomDialogs>().hideCircularDialog(context);

        Get.toNamed(Routes.OTP_SCREEN, arguments: {
          ArgumentConstant.verificationId: verificationId,
          ArgumentConstant.resendToken: resendToken,
          ArgumentConstant.countryCode: countryCode,
          ArgumentConstant.mobileNo: countryCode + numberController.text,
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    )
        .catchError((e) {
      getIt<CustomDialogs>().hideCircularDialog(context);

      print(e.toString());
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
