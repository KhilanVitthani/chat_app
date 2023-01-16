// Common TextFiel
import 'package:chat_app/app/constants/color_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/sizeConstant.dart';

Widget commonTextField({
  TextEditingController? controller,
  String? hintText,
  String? labelText,
  String? counterText,
  FormFieldValidator<String>? validation,
  bool needValidation = false,
  bool? urlValidation = false,
  String? validationMessage,
  double? horizontal,
  iconButton,
  Widget? prefixButton,
  Widget? suffix,
  double? vertical,
  double? lcPadding,
  double? tcPadding,
  double? rcPadding,
  double? bcPadding,
  bool readyOnly = false,
  Function? onPressed,
  bool hintTextBold = false,
  bool showBfBorder = true,
  bool showBeBorder = true,
  bool titleTextBold = false,
  bool labelTextBold = false,
  bool fillColor = false,
  bool textAlign = false,
  bool showNumber = false,
  double? hintFontSize,
  double? labelFontSize,
  double? textSize,
  Color? fbColor,
  Color? ebColor,
  Color? hintTextColor,
  Color? labelTextColor,
  Color? textColor,
  int? maxLength,
  int? maxLines,
  List<TextInputFormatter>? inputFormatters,
  TextInputType? keyBoardTypeEnter,
  bool? isPassWordValidation = false,
  bool? isMobileValidation = false,
  bool? isEmailValidation = false,
  bool? isNameCapital = false,
  bool? isSentence = false,
  bool obscureText = false,
  Function(String?)? onChangedValue,
  TextInputAction? textInputAction,
  double borderRadius = 10,
}) {
  return Padding(
    padding: EdgeInsets.symmetric(
      horizontal: horizontal ?? 0,
      vertical: vertical ?? 0,
    ),
    child: TextFormField(
      onChanged: onChangedValue,
      textCapitalization: (isNameCapital ?? false)
          ? TextCapitalization.words
          : TextCapitalization.none,
      obscureText: obscureText,
      controller: controller,
      keyboardType: showNumber ? TextInputType.number : TextInputType.text,
      textAlign: textAlign ? TextAlign.right : TextAlign.start,
      textInputAction: textInputAction ?? TextInputAction.done,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontWeight: titleTextBold ? FontWeight.bold : FontWeight.normal,
        fontSize: textSize ?? 16,
      ),
      maxLines: maxLines,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(
          left: lcPadding ?? 15,
          top: MySize.getHeight(tcPadding ?? 10),
          right: rcPadding ?? 0,
          bottom: bcPadding ?? 10,
        ),
        suffix: suffix,

        // suffixIconColor: Colors.black,
        fillColor: fillColor ? appTheme.backgroungGray : Colors.transparent,
        focusedBorder: showBfBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: fbColor ?? appTheme.primary,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: fbColor ?? appTheme.primary,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        enabledBorder: showBeBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: fbColor ?? appTheme.borderGrayColor,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.transparent,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        focusedErrorBorder: showBfBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        errorBorder: showBeBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              )
            : UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.red,
                ),
                borderRadius: BorderRadius.circular(borderRadius),
              ),
        counterText: counterText == "" ? null : "",
        filled: true,

        suffixIcon: iconButton,
        prefixIcon: prefixButton,
        labelText: labelText,
        labelStyle: TextStyle(
          color: labelTextColor ?? Colors.grey,
          fontWeight: labelTextBold ? FontWeight.bold : FontWeight.normal,
          fontSize: labelFontSize ?? 16,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: hintTextColor ?? appTheme.textGrayHintColor,
          fontWeight: hintTextBold ? FontWeight.bold : FontWeight.w500,
          fontSize: hintFontSize ?? MySize.getHeight(16),
        ),
        border: const OutlineInputBorder(),
      ),
      inputFormatters: inputFormatters ?? [],
      onTap: onPressed as void Function()?,
      maxLength: maxLength,
      readOnly: readyOnly,
      validator: validation,
    ),
  );
}

// TextFormField getTextFormField(
//     {TextEditingController? textEditingController,
//     FormFieldValidator<String>? validation,
//     TextInputType? textInputType,
//     Function? ontap,
//     double? size = 52,
//     Widget? suffix,
//     Widget? suffixIcon,
//     bool textVisible = false,
//     double? borderRadius,
//     bool? isFillColor = false,
//     Widget? prefixIcon,
//     List<TextInputFormatter>? formator,
//     bool isReadOnly = false,
//     Function(String)? onChanged,
//     Color enabledBorder = Colors.black,
//     Color focusedBorder = Colors.black,
//     Color border = Colors.black,
//     bool enable = true,
//     String? hintText,
//     int? maxLine = 1}) {
//   return TextFormField(
//     controller: textEditingController,
//     cursorColor: Colors.black,
//     readOnly: isReadOnly,
//     obscureText: textVisible,
//     enabled: enable,
//     inputFormatters: formator,
//     validator: validation,
//     onChanged: onChanged,
//     keyboardType: textInputType,
//     maxLines: maxLine,
//     decoration: InputDecoration(
//       filled: isFillColor,
//       fillColor: AppColor.backgroungGray,
//       enabledBorder: OutlineInputBorder(
//         borderSide: BorderSide(color: enabledBorder),
//         borderRadius: BorderRadius.circular(
//             (borderRadius == null) ? MySize.size10! : borderRadius),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(
//             (borderRadius == null) ? MySize.size10! : borderRadius),
//         borderSide: BorderSide(color: focusedBorder),
//       ),
//       border: OutlineInputBorder(
//         borderSide: BorderSide(color: border),
//         borderRadius: BorderRadius.circular(
//             (borderRadius == null) ? MySize.size10! : borderRadius),
//       ),
//       contentPadding: EdgeInsets.only(
//         left: MySize.size20!,
//         right: MySize.size10!,
//         bottom: size! / 2, // HERE THE IMPORTANT PART
//       ),
//       prefixIcon: prefixIcon,
//       suffixIcon: suffixIcon,
//       suffix: suffix,
//       hintText: hintText,
//       hintStyle: TextStyle(
//         fontSize: MySize.size16!,
//       ),
//     ),
//   );
// }
