import 'package:flutter/material.dart';

import 'core/resources/app_colors.dart';

final theme = ThemeData(
  unselectedWidgetColor: Colors.white,
  scrollbarTheme: ScrollbarThemeData(),
  // textTheme: GoogleFonts.openSansTextTheme(),
  useMaterial3: true,
  fontFamily: 'Cairo',

  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: const Color(0xFFB2EBF2),
  primaryColor: const Color(0xFF00BCD4),
  // colorScheme: const ColorScheme.light(background: Color(0xFF009688)),
  colorScheme: ColorScheme.light(
    background: AppColors.scaffoldBackGround.withOpacity(0.1),
    primary: AppColors.blueBlack,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      foregroundColor: AppColors.blueBlack,
      backgroundColor: AppColors.babyBlue,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    foregroundColor: AppColors.blueBlack,
  )),
  // scaffoldBackgroundColor: AppColors.scaffoldBackGround,
  dialogTheme:
      const DialogTheme(backgroundColor: AppColors.grey2, elevation: 0),
  indicatorColor: AppColors.blue,
  // backgroundColor: Colors.grey[100],
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: AppColors.white),
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.white, width: 2.0),
      borderRadius: BorderRadius.circular(25),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.white, width: 2.0),
      borderRadius: BorderRadius.circular(15),
    ),
  ),
);
