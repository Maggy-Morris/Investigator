import 'package:flutter/material.dart';
import 'package:Investigator/core/resources/app_colors.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    @required this.title,
    this.fontSize,
    this.textAlign,
    this.textColor,
    this.fontWeight,
    this.maxLine,
    this.overflow,
    this.textDecoration,
  })  : assert(title != null),
        super(key: key);
  final String? title;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLine;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      title!,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: overflow,
      softWrap: true,
      style: TextStyle(
          fontSize: fontSize,
          color: textColor,
          fontWeight: fontWeight,
          decoration: textDecoration),
    );
  }
}

Widget headerView(String title, String subTitle,bool isDark) {
  return CustomText(
    title: title,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    textColor: isDark ? AppColors.white : AppColors.black,
  );
  // return Column(
  //   mainAxisSize: MainAxisSize.min,
  //   children: [
  //     CustomText(
  //       title: title,
  //       fontSize: 28,
  //       fontWeight: FontWeight.w700,
  //       textColor: isDark ? AppColors.white : AppColors.black,
  //     ),
  //     FxBox.h6,
  //     CustomText(
  //       title: subTitle,
  //       fontSize: 16,
  //       textAlign: TextAlign.center,
  //       fontWeight: FontWeight.w400,
  //       textColor: isDark ? AppColors.white : AppColors.black,
  //     ),
  //   ],
  // );
}
