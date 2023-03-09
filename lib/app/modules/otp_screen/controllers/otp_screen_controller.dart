import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import '../../../service/firebase_service.dart';
import '../../../utilities/progress_dialog_utils.dart';

class OtpScreenController extends GetxController {
  TextEditingController otpController = TextEditingController();
  FocusNode focusNode = FocusNode();
  PinTheme defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 22,
      color: Color.fromRGBO(30, 60, 87, 1),
    ),
    decoration: BoxDecoration(),
  );
  Widget cursor = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
  Widget preFilledWidget = Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        width: 56,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ],
  );
  String mobileNo = "";

  Duration myDuration = Duration(minutes: 1);
  RxString minute = "1".obs;
  Timer? countdownTimer;

  RxString sec = "00".obs;
  RxBool showResendOtp = false.obs;
  int? resendToken;
  String? verificationId;
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      resendToken = Get.arguments[ArgumentConstant.resendToken];
      verificationId = Get.arguments[ArgumentConstant.verificationId];
      mobileNo = Get.arguments[ArgumentConstant.mobileNo];
      startTimer();
    }
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  // Step 4
  void stopTimer() {
    countdownTimer!.cancel();
  }

  // Step 5
  void resetTimer() {
    stopTimer();
    myDuration = Duration(minutes: 1);
  }

  // Step 6
  void setCountDown() {
    final reduceSecondsBy = 1;

    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
      showResendOtp.value = true;
    } else {
      myDuration = Duration(seconds: seconds);
      String strDigits(int n) => n.toString().padLeft(2, '0');
      final days = strDigits(myDuration.inDays);
      // Step 7
      final hours = strDigits(myDuration.inHours.remainder(24));
      minute.value = strDigits(myDuration.inMinutes.remainder(60));
      sec.value = strDigits(myDuration.inSeconds.remainder(60));
    }
  }

  verifyOtp(BuildContext context) async {
    FocusScope.of(context).unfocus();

    getIt<CustomDialogs>().showCircularDialog(context);
    await FirebaseAuth.instance
        .signInWithCredential(PhoneAuthProvider.credential(
            verificationId: verificationId!, smsCode: otpController.text))
        .then((value) async {
      if (value != null) {
        UserModel? userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!, uid: value.user!.uid, isLoad: false);
        getIt<CustomDialogs>().hideCircularDialog(context);

        if (!isNullEmptyOrFalse(userData)) {
          if (userData != null && userData.isVerified == true) {
            Get.offAllNamed(Routes.HOME);
            box.write(ArgumentConstant.userUid, value.user!.uid);
          } else {
            await getIt<FirebaseService>().addTempUserDataToFireStore(
                data: {"uId": value.user!.uid, "isVerified": false},
                uUid: value.user!.uid).then((va) {
              Get.offAllNamed(Routes.SIGN_UP, arguments: {
                ArgumentConstant.userData: value.user!,
                ArgumentConstant.signInType: SignInType.google,
              });
            });
          }
        }
      }
    }).catchError((e) {
      getIt<CustomDialogs>().hideCircularDialog(context);
      getIt<CustomDialogs>()
          .getDialog(title: "Invalid OTP", desc: "Please provide right OTP.");
    });
  }

  reSendOtp(BuildContext context) async {
    getIt<CustomDialogs>().showCircularDialog(context);

    await FirebaseAuth.instance
        .verifyPhoneNumber(
      phoneNumber: mobileNo,
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
      codeSent: (String verificationIdNew, int? resendTokenNew) {
        getIt<CustomDialogs>().hideCircularDialog(context);
        verificationId = verificationIdNew;
        resendToken = resendTokenNew;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // getIt<CustomDialogs>().hideCircularDialog(context);
        print("CART ::: $verificationId");
      },
    )
        .catchError((e) {
      getIt<CustomDialogs>().hideCircularDialog(context);

      print(e.toString());
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
