import 'package:flutter/material.dart';
import 'package:luminalens/core/resources/app_colors.dart';

Widget getCardBadgesRow({required List<String> badgesList}) {
  return Wrap(
    children: List.generate(badgesList.length, (index) => Card(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.scaffoldBackGround,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
        child: Text(
          badgesList[index].toString(),
          style: const TextStyle(
            color: AppColors.blueBlack,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ),),
  );
}