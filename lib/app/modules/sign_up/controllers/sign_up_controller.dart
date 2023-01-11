import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';

class SignUpController extends GetxController {
  //TODO: Implement SignUpController

  final count = 0.obs;
  Rx<bool> profileImg = false.obs;
  Rx<bool> isImageSelected = false.obs;
  String? imgFileName;
  final imgPicker = ImagePicker();
  Rx<File>? imgFile;
  late Rx<SingleValueDropDownController> selectUserLevelType;

  Rx<File?>? profile;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> secondNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  RxBool isHidden = true.obs;
  RxBool isHiddenConfirm = true.obs;
  @override
  void onInit() {
    super.onInit();
    selectUserLevelType = SingleValueDropDownController().obs;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<File?> openCamera() async {
    String? imgCamera;
    await imgPicker.pickImage(source: ImageSource.camera).then((value) {
      imgCamera = value!.path;
      print(imgCamera);
      imgFile = File(imgCamera!).obs;
      return imgFile!.value;
    }).catchError((error) {
      print(error);
    });

    return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
  }

  Future<File?> openGallery() async {
    String? imgGallery;
    await imgPicker.pickImage(source: ImageSource.gallery).then((value) {
      imgGallery = value!.path;

      imgFile = File(imgGallery!).obs;
      print(imgFile);
      imgFile!.refresh();
    });

    return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
  }

  Future<void> cropImage({
    File? pickedFile,
    BuildContext? context,
    bool isFromEnhancer = false,
    bool isFromImageEnlarger = false,
  }) async {
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset
          //     .original,
          CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset
          //     .ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: appTheme.primaryTheme,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: Get.context!,
          ),
        ],
      );
      if (croppedFile != null) {
        Get.back();
        profile = File(croppedFile.path).obs;
        imgFileName = p.basename(croppedFile.path);
        count.value++;
      } else {
        // controller.profile =
        //     File(image.path).obs;
        // controller.imgFileName = p
        //     .basename(image.path);
      }
    }
  }

  void increment() => count.value++;
}
