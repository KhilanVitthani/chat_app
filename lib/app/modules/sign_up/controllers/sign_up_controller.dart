import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

import '../../../constants/app_constant.dart';
import '../../../constants/color_constant.dart';
import '../../../constants/sizeConstant.dart';
import '../../../service/location.dart';

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

  Rx<PageController> pageController = PageController().obs;
  RxInt n = 1.obs;

  Rx<TextEditingController> firstNameController = TextEditingController().obs;
  Rx<TextEditingController> secondNameController = TextEditingController().obs;
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> passwordController = TextEditingController().obs;
  Rx<TextEditingController> confirmPasswordController =
      TextEditingController().obs;
  Rx<GlobalKey<FormState>> formKey1 = GlobalKey<FormState>().obs;
  Rx<GlobalKey<FormState>> formKey2 = GlobalKey<FormState>().obs;
  Rx<GlobalKey<FormState>> formKey3 = GlobalKey<FormState>().obs;
  RxBool isHidden = true.obs;
  RxBool isHiddenConfirm = true.obs;
  User? user;
  SignInType signInType = SignInType.google;

  @override
  void onInit() {
    super.onInit();
    selectUserLevelType = SingleValueDropDownController().obs;
    if (Get.arguments != null) {
      if (Get.arguments[ArgumentConstant.userData] != null) {
        user = Get.arguments[ArgumentConstant.userData];
        if (user!.displayName != null) {
          firstNameController.value.text = user!.displayName.toString();
        }
        if (user!.email != null) {
          emailController.value.text = user!.email.toString();
        }
      }
      if (Get.arguments[ArgumentConstant.signInType] != null) {
        signInType = Get.arguments[ArgumentConstant.signInType];
      }
    }
  }

  double distance = 50;
  bool isCreating = false;
  bool _isObscure = true;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _nameController = TextEditingController();
  Rx<TextEditingController> addressController = TextEditingController().obs;
  final _formKey = GlobalKey<FormState>();
  GeoPoint latLng = GeoPoint(0, 0);
  String level = '1';
  RxString city = ''.obs;
  RxString state = ''.obs;
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setLocation() async {
    List coordinates = await getUserCurrentCoordinates();

    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: googleApiKey,
          onPlacePicked: (result) async {
            /*Show full address*/
            // addressController.value.text =
            //     await result.formattedAddress.toString();
            List<Placemark> placemarks = await placemarkFromCoordinates(
                result.geometry!.location.lat, result.geometry!.location.lng);
            if (!isNullEmptyOrFalse(placemarks)) {
              Placemark a = placemarks.first;
              if (!isNullEmptyOrFalse(a.locality)) {
                city.value = a.locality.toString() + ", ";
              }
              if (!isNullEmptyOrFalse(a.administrativeArea)) {
                state.value = a.administrativeArea.toString() + ", ";
              }
            }
            /*Show only  city & state*/
            addressController.value.text = city.value + state.value + ".";
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(coordinates[0], coordinates[1]),
          useCurrentLocation: true,
        ),
      ),
    );
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
        // cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          // CropAspectRatioPreset.ratio3x2,
          // CropAspectRatioPreset.original,
          // CropAspectRatioPreset.ratio4x3,
          // CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: appTheme.primaryTheme,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: true,
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
