// class RectanglePainter extends CustomPainter {
//   final List<List<double>> coordinates;

//   RectanglePainter(this.coordinates);

//   @override
//   void paint(Canvas canvas, Size size) {
//     // print('Painting rectangle...');

//     final paint = Paint()
//       ..color = Colors.red
//       ..strokeWidth = 2.0
//       ..style = PaintingStyle.stroke;

//     for (final coord in coordinates) {
//       if (coord.length == 4) {
//         final left = coord[0];
//         final top = coord[1];
//         final right = coord[2];
//         final bottom = coord[3];
//         // final top = coord[0];
//         // final left = coord[1];
//         // final bottom = coord[2];
//         // final right = coord[3];

//         final topLeft = Offset(left, top);
//         final topRight = Offset(right, top);
//         final bottomRight = Offset(right, bottom);
//         final bottomLeft = Offset(left, bottom);

//         canvas.drawLine(topLeft, topRight, paint);
//         canvas.drawLine(topRight, bottomRight, paint);
//         canvas.drawLine(bottomRight, bottomLeft, paint);
//         canvas.drawLine(bottomLeft, topLeft, paint);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(RectanglePainter oldDelegate) {
//     return coordinates != oldDelegate.coordinates;
//   }
// }

import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  final List<List<double>> coordinates;
  final List<String> texts;
  final List<String> personNameRectangle;
  final List<String> blacklis;

  RectanglePainter(
      this.blacklis, this.personNameRectangle, this.coordinates, this.texts);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    const textStyle = TextStyle(
      color: Colors.red,
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
    );

    const warningIcon = Icons.warning_amber;
    const iconSize = 25.0;

    for (int i = 0; i < coordinates.length; i++) {
      final coord = coordinates[i];
      if (coord.length == 4) {
        final left = coord[0];
        final top = coord[1];
        final right = coord[2];
        final bottom = coord[3];

        final topLeft = Offset(left, top);
        final topRight = Offset(right, top);
        final bottomRight = Offset(right, bottom);
        final bottomLeft = Offset(left, bottom);

// Draw first text on top of rectangle
        final firstTextPainter = TextPainter(
          text: TextSpan(
            text: " ${personNameRectangle[i]}  Conf. :${texts[i]}",
            style: textStyle,
          ),
          textDirection: TextDirection.ltr,
        );

        firstTextPainter.layout();
        final firstTextOffset = Offset(left, top - 25);
        firstTextPainter.paint(canvas, firstTextOffset);

        final textBounds = Rect.fromLTWH(
            left,
            top - 30,
            10 + firstTextPainter.size.width,
            // (personNameRectangle[i].si.toDouble() +
            //     "  Conf. :".length.toDouble() +
            //     texts[i].length.toDouble()),
            30);
        // Draw background rectangle for text
        final textPaint = Paint()
          ..color = Colors.black.withOpacity(0.6); // Amber color

        canvas.drawRect(textBounds, textPaint);

        // Draw rectangle
        canvas.drawLine(topLeft, topRight, paint);
        canvas.drawLine(topRight, bottomRight, paint);
        canvas.drawLine(bottomRight, bottomLeft, paint);
        canvas.drawLine(bottomLeft, topLeft, paint);

        // Draw warning icon if needed

        if (blacklis[i] == 'True') {
          // Replace true with your boolean condition
          drawIcon(canvas, warningIcon, Colors.red, iconSize,
              Offset(left + (right - left) / 2, top - 50));
        }

        // Draw second text on top of rectangle
        // final secondTextPainter = TextPainter(
        //   text: TextSpan(
        //     text: ".",
        //     style: textStyle,
        //   ),
        //   textDirection: TextDirection.ltr,
        // );
        // secondTextPainter.layout();
        // final secondTextOffset = Offset(left + 100, top - 25);
        // secondTextPainter.paint(canvas, secondTextOffset);
      }
    }
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) {
    return coordinates != oldDelegate.coordinates || texts != oldDelegate.texts;
  }

  void drawIcon(
      Canvas canvas, IconData icon, Color color, double size, Offset offset) {
    final textSpan = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontFamily: icon.fontFamily,
        fontSize: size,
        color: color,
      ),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size);
    final offset2 = Offset(
        offset.dx - textPainter.width / 2, offset.dy - textPainter.height / 2);
    textPainter.paint(canvas, offset2);
  }
}
