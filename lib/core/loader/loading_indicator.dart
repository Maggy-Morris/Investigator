import 'package:flutter/material.dart';
import 'package:Investigator/core/resources/app_colors.dart';

import 'spining_lines_loader.dart';

Widget loadingIndicator({Color? color}){
  return Center(
    child: SpinningLinesLoader(
      color: color ?? AppColors.buttonBlue,
      duration: const Duration(milliseconds: 3000),
      itemCount: 3,
      size: 50,
      lineWidth: 2,
    ),
  );
}