import 'package:Investigator/core/resources/app_colors.dart';
import 'package:flutter/material.dart';

class FullScreenImageFromUrl extends StatelessWidget {
  final String imageUrl;
  final String text;

  const FullScreenImageFromUrl(
      {Key? key, required this.imageUrl, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey2,
      appBar: AppBar(
        backgroundColor: AppColors.backGround,

        iconTheme: const IconThemeData(
            color: Colors.white), // Set back button color to white
        title: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            );
          },
          errorBuilder:
              (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text('Failed to load image');
          },
          fit: BoxFit.cover,
          // You can add more customization to the image widget as needed
        ),
      ),
    );
  }
}
