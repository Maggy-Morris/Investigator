import 'package:Investigator/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String text;

  const FullScreenImage(
      {super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey2,
      appBar: AppBar(
        backgroundColor: AppColors.backGround,
        // Customize app bar if needed
        title: Text(
          text,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          color: Colors.transparent,
          // You can add more customization to the image widget as needed
        ),
      ),
    );
  }
}
