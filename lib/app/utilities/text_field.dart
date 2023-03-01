import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/color_constant.dart';
import '../constants/sizeConstant.dart';

TextFormField getTextField({
  String? hintText,
  String? labelText,
  TextEditingController? textEditingController,
  Widget? prefixIcon,
  double? borderRadius,
  Widget? suffixIcon,
  double? size = 70,
  Widget? suffix,
  Color? borderColor,
  Color? fillColor,
  bool isFilled = false,
  Color? labelColor,
  TextInputType textInputType = TextInputType.name,
  TextInputAction textInputAction = TextInputAction.next,
  bool textVisible = false,
  bool readOnly = false,
  VoidCallback? onTap,
  int maxLine = 1,
  int? maxLength,
  String errorText = "",
  Function(String)? onChange,
  FormFieldValidator<String>? validation,
  double fontSize = 15,
  double hintFontSize = 14,
  bool inlineBorder = false,
  double? topPadding,
  double? leftPadding,
  FocusNode? focusNode,
  void Function(String)? onChanged,
  TextCapitalization textCapitalization = TextCapitalization.none,
}) {
  return TextFormField(
    controller: textEditingController,
    obscureText: textVisible,
    textInputAction: textInputAction,
    keyboardType: textInputType,
    focusNode: focusNode,
    textCapitalization: textCapitalization,
    cursorColor: appTheme.primaryTheme,
    readOnly: readOnly,
    validator: validation,
    onTap: onTap,
    maxLines: maxLine,
    onChanged: onChange,
    style: TextStyle(
      fontSize: MySize.getHeight(fontSize),
    ),
    maxLength: maxLength ?? null,
    decoration: InputDecoration(
      fillColor: fillColor ?? appTheme.textGrayColor,
      // isDense: inlineBorder,
      filled: isFilled,
      labelText: labelText,
      labelStyle: TextStyle(
          color: labelColor ?? appTheme.primaryTheme,
          fontWeight: FontWeight.w600),
      enabledBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderSide:
                  BorderSide(color: borderColor ?? appTheme.primaryTheme),
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
            ),
      focusedBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
              borderSide:
                  BorderSide(color: borderColor ?? appTheme.primaryTheme),
            ),
      errorBorder: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
              borderSide:
                  BorderSide(color: borderColor ?? appTheme.primaryTheme),
            ),
      border: (inlineBorder)
          ? UnderlineInputBorder(
              borderSide: BorderSide(
                  color: borderColor ?? Color(0xff262626).withOpacity(0.5)))
          : OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                  (borderRadius == null) ? MySize.getHeight(5) : borderRadius),
            ),
      contentPadding: EdgeInsets.only(
        left: (inlineBorder) ? -30 : MySize.getWidth(20),
        right: MySize.getWidth(10),
        bottom: (inlineBorder) ? MySize.getHeight(0) : size! / 2, //
        top: (inlineBorder)
            ? MySize.getHeight(topPadding ?? 0)
            : 0, // HERE THE IMPORTANT PART
      ),
      prefixIconConstraints:
          inlineBorder ? BoxConstraints(minWidth: leftPadding ?? 0) : null,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorMaxLines: 2,
      errorText: (isNullEmptyOrFalse(errorText)) ? null : errorText,
      hintText: hintText,
      hintStyle: TextStyle(
          fontSize: MySize.getHeight(hintFontSize),
          color: Colors.grey.shade500),
    ),
  );
}

Widget getUnderLineTextBox({
  required TextEditingController textController,
  FormFieldValidator<String>? validation,
  String? hintText,
  Widget? prefix,
  TextInputType textInputType = TextInputType.text,
  TextInputAction textInputAction = TextInputAction.next,
  VoidCallback? onTap,
  bool readOnly = false,
  Color? borderColor,
  Widget? suffix,
  FocusNode? focusNode,
  Widget? suffixIcon,
  double? size,
  required double height,
  required double width,
  void Function(String)? onChanged,
  double? topPadding,
  double? leftPadding,
}) {
  return Container(
    height: MySize.getHeight(height),
    width: MySize.getWidth(width),
    child: getTextField(
      inlineBorder: true,
      textEditingController: textController,
      textInputAction: textInputAction,
      focusNode: focusNode,
      fillColor: Colors.transparent,
      size: size,
      textInputType: textInputType,
      hintText: hintText,
      borderColor: borderColor,
      prefixIcon: (isNullEmptyOrFalse(prefix)) ? SizedBox() : prefix,
      validation: validation,
      onTap: onTap,
      suffix: suffix,
      suffixIcon: suffixIcon,
      readOnly: readOnly,
      onChanged: onChanged,
      topPadding: topPadding,
      leftPadding: leftPadding,
    ),
  );
}
