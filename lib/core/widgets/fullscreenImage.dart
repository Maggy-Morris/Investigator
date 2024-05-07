import 'dart:convert';
import 'dart:typed_data';

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
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white

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
          // color: Colors.transparent,
          // You can add more customization to the image widget as needed
        ),
      ),
    );
  }
}

class FullScreenImageFromMemory extends StatelessWidget {
  final String imageUrl;
  final String text;

  const FullScreenImageFromMemory(
      {super.key, required this.imageUrl, required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey2,
      appBar: AppBar(
        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white

        backgroundColor: AppColors.backGround,
        // Customize app bar if needed
        title: Text(
          text,
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Center(
        child: Image.memory(
          _decodeBase64Image(base64Image: imageUrl),
          fit: BoxFit.cover,
          // color: Colors.transparent,
          // You can add more customization to the image widget as needed
        ),
      ),
    );
  }

  Uint8List _decodeBase64Image({required String base64Image}) {
    final bytes = base64.decode(base64Image);
    return Uint8List.fromList(bytes);
  }
}
