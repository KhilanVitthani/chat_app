import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../main.dart';
import '../../../constants/app_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../model/user_model.dart';
import '../../../provider/UserDataProvider.dart';
import '../../../provider/card_provider.dart';
import '../../../service/firebase_service.dart';

class AddUserController extends GetxController {
  //TODO: Implement AddUserController

  final count = 0.obs;
  UserModel? userData;
  RxBool hasData = false.obs;
  RxInt lastUpdated = 0.obs;
  Rx<CarouselController> carouselController = CarouselController().obs;

  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (!isNullEmptyOrFalse(box.read(ArgumentConstant.userUid))) {
        userData = await getIt<FirebaseService>().getUserData(
            context: Get.context!,
            uid: box.read(ArgumentConstant.userUid),
            isLoad: false);
        print(userData);
      }
      hasData.value = true;
      final cardProvider =
          Provider.of<CardProvider>(Get.context!, listen: false);
      final provider =
          Provider.of<UserDataProvider>(Get.context!, listen: false);

      lastUpdated.value = provider.userData!.lastUpdatedAt ?? 0;
      if (lastUpdated == 0) {
        lastUpdated.value = DateTime.now().millisecondsSinceEpoch;
      }

      cardProvider.reset();
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
