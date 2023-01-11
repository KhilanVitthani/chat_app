import 'package:chat_app/app/constants/color_constant.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

import '../constants/sizeConstant.dart';

Widget getDropDownTextField(
    {required SingleValueDropDownController? controller,
    required List<DropDownValueModel> list,
    ValueSetter? onChange,
    FormFieldValidator<String>? validation,
    double? lcPadding,
    double? tcPadding,
    String? initialValue,
    double? rcPadding,
    double? bcPadding,
    required String hintText}) {
  return DropDownTextField(
    // initialValue: "name4",
    controller: controller,

    clearOption: false,
    enableSearch: false,

    validator: validation,
    textFieldDecoration: InputDecoration(
      contentPadding: EdgeInsets.only(
        left: lcPadding ?? 15,
        top: MySize.getHeight(tcPadding ?? 10),
        right: rcPadding ?? 0,
        bottom: bcPadding ?? 10,
      ),
      fillColor: Colors.transparent,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: appTheme.borderGrayColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      suffixIcon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          size: MySize.getHeight(20),
        ),
        // child: Image.asset(
        //   AppAsset.arrowIcon,
        //   height: MySize.size21,
        //   width: MySize.size21,
        //   color: Colors.black,
        //   fit: BoxFit.fitHeight,
        // ),
      ),

      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: appTheme.borderGrayColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      // counterText: counterText == "" ? null : "",
      filled: true,
      // suffixIcon: iconButton,
      // prefixIcon: prefixButton,
      // labelText: labelText,
      labelStyle: TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      hintText: hintText,
      hintStyle: TextStyle(
        color: appTheme.textGrayHintColor,
        fontWeight: FontWeight.w500,
        fontSize: MySize.getHeight(16),
      ),
      border: const OutlineInputBorder(),
    ),
    // dropDownItemCount: 6,
    dropDownList: list,
    onChanged: onChange,
  );
}
