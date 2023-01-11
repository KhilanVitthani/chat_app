import 'package:chat_app/app/constants/color_constant.dart';
import 'package:flutter/material.dart';

import '../constants/sizeConstant.dart';

GestureDetector button({
  double height = 50,
  double width = 341,
  String? title = "",
  Color? backgroundColor,
  Color? borderColor,
  Color? textColor,
  Widget? widget,
  double? fontsize = 14,
  double? radius = 6,
  GestureTapCallback? onTap,
}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: Container(
      height: MySize.getHeight(height),
      width: MySize.getWidth(width),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(
            color: (borderColor == null) ? Colors.transparent : borderColor,
            width: 1),
        color:
            (backgroundColor == null) ? appTheme.primaryTheme : backgroundColor,
      ),
      alignment: Alignment.center,
      child: (widget != null)
          ? Center(child: widget)
          : Text(
              title!,
              style: TextStyle(
                  color: (textColor == null) ? Colors.white : textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: MySize.getHeight(fontsize!)),
            ),
    ),
  );
}

// Container buttonGredient({
//   double height = 50,
//   double width = 341,
//   String? title = "",
//   Color? backgroundColor,
//   Color? borderColor,
//   Color? textColor,
//   Widget? widget,
//   double? fontsize = 14,
//   double? radius = 6,
//   bool isSelected = true,
// }) {
//   return Container(
//     height: MySize.getScaledSizeHeight(height),
//     width: MySize.getScaledSizeWidth(width),
//     decoration: (isSelected)
//         ? BoxDecoration(
//             borderRadius: BorderRadius.circular(radius!),
//             // gradient: LinearGradient(
//             //   // colors: [
//             //   //   AppColor.gredientColor1,
//             //   //   AppColor.gredientColor2,
//             //   // ],
//             //   begin: Alignment.bottomLeft,
//             //   end: Alignment.topRight,
//             // ),
//             border: Border.all(
//                 color: (borderColor == null) ? Colors.transparent : borderColor,
//                 width: 1),
//             color:
//                 (backgroundColor == null) ? AppColor.primary : backgroundColor,
//           )
//         : BoxDecoration(
//             borderRadius: BorderRadius.circular(radius!),
//             // gradient: LinearGradient(
//             //   colors: [
//             //     AppColor.gredientColor1,
//             //     AppColor.gredientColor2,
//             //   ],
//             //   begin: Alignment.bottomLeft,
//             //   end: Alignment.topRight,
//             // ),
//             border: Border.all(
//                 color: (borderColor == null) ? Colors.transparent : borderColor,
//                 width: 1),
//             color:
//                 (backgroundColor == null) ? AppColor.primary : backgroundColor,
//           ),
//     alignment: Alignment.center,
//     child: (widget != null)
//         ? Center(child: widget)
//         : Text(
//             title!,
//             style: TextStyle(
//                 color: (textColor == null) ? Colors.white : textColor,
//                 fontWeight: FontWeight.bold,
//                 fontSize: MySize.getScaledSizeHeight(fontsize!)),
//           ),
//   );
// }
class RoundedGradientButton extends StatelessWidget {
  final Function? onTap;
  final double? marginTop;
  final double? marginLeft;
  final double? marginRight;
  final double? marginBottom;
  final String text;
  final TextAlign? textAlign;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? borderRadius;
  final double? borderRadiusTopLeft;
  final double? borderRadiusTopRight;
  final double? borderRadiusBottomLeft;
  final double? borderRadiusBottomRight;
  final Color? textColor;
  final Color? shadowColor;
  final List<Color> colors;
  final FontWeight? fontWeight;

  const RoundedGradientButton({
    Key? key,
    required this.text,
    this.fontWeight,
    this.textAlign,
    this.marginTop = 0,
    this.marginLeft = 0,
    this.marginRight = 0,
    this.marginBottom = 0,
    this.fontSize,
    this.width,
    this.height,
    this.borderRadius,
    this.borderRadiusTopLeft = 0,
    this.borderRadiusTopRight = 0,
    this.borderRadiusBottomLeft = 0,
    this.borderRadiusBottomRight = 0,
    this.textColor,
    this.shadowColor,
    this.colors = const [Colors.red, Colors.blue],
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      padding: EdgeInsets.all(0.0),
      shadowColor: shadowColor != null ? shadowColor : colors[0],
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius != null
            ? BorderRadius.all(Radius.circular(borderRadius!))
            : BorderRadius.only(
                topLeft: Radius.circular(borderRadiusTopLeft!),
                topRight: Radius.circular(borderRadiusTopRight!),
                bottomLeft: Radius.circular(borderRadiusBottomLeft!),
                bottomRight: Radius.circular(borderRadiusBottomRight!),
              ),
      ),
    );

    return Container(
      width: width,
      height: height,
      margin: EdgeInsets.only(
          left: marginLeft!,
          top: marginTop!,
          bottom: marginBottom!,
          right: marginRight!),
      child: ElevatedButton(
        onPressed: onTap as void Function()?,
        style: flatButtonStyle,
        child: Ink(
          width: size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: borderRadius != null
                ? BorderRadius.all(Radius.circular(borderRadius!))
                : BorderRadius.only(
                    topLeft: Radius.circular(borderRadiusTopLeft!),
                    topRight: Radius.circular(borderRadiusTopRight!),
                    bottomLeft: Radius.circular(borderRadiusBottomLeft!),
                    bottomRight: Radius.circular(borderRadiusBottomRight!),
                  ),
          ),
          child: Container(
            width: size.width,
            constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              text,
              textAlign: textAlign,
              style: TextStyle(
                fontSize: fontSize,
                color: textColor,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
