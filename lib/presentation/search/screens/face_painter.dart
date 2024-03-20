// import 'package:flutter/material.dart';

// class FacePainter extends CustomPainter {
//   final ui.Image image;
//   final List<Face> faces;
//   final List<Rect> rects = [];

//   FacePainter(this.image, this.faces) {
//     for (var i = 0; i < faces.length; i++) {
//       rects.add(faces[i].boundingBox);
//     }
//   }

//   @override
//   void paint(ui.Canvas canvas, ui.Size size) {
//     final Paint paint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 15.0
//       ..color = Colors.yellow;

//     canvas.drawImage(image, Offset.zero, Paint());
//     for (var i = 0; i < faces.length; i++) {
//       canvas.drawRect(rects[i], paint);
//     }
//   }

//   @override
//   bool shouldRepaint(FacePainter oldDelegate) {
//     return image != oldDelegate.image || faces != oldDelegate.faces;
//   }
// }

// CustomPaint(
//                                                         painter:
//                                                             RectanglePainter(
//                                                           state.boxes
//                                                                   ?.map((box) =>
//                                                                       Offset(
//                                                                           box[0],
//                                                                           box[1]))
//                                                                   .toList() ??
//                                                               [],
//                                                         ),

import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  final List<List<double>> coordinates;

  RectanglePainter(this.coordinates);

  @override
  void paint(Canvas canvas, Size size) {
    print('Painting rectangle...');

    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final coord in coordinates) {
      if (coord.length == 4) {
        final left = coord[0];
        final top = coord[1];
        final right = coord[2];
        final bottom = coord[3];

        final topLeft = Offset(left, top);
        final topRight = Offset(right, top);
        final bottomRight = Offset(right, bottom);
        final bottomLeft = Offset(left, bottom);

        canvas.drawLine(topLeft, topRight, paint);
        canvas.drawLine(topRight, bottomRight, paint);
        canvas.drawLine(bottomRight, bottomLeft, paint);
        canvas.drawLine(bottomLeft, topLeft, paint);
      }
    }
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) {
    return coordinates != oldDelegate.coordinates;
  }
}
