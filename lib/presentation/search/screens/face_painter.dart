import 'package:flutter/material.dart';

class RectanglePainter extends CustomPainter {
  final List<List<double>> coordinates;

  RectanglePainter(this.coordinates);

  @override
  void paint(Canvas canvas, Size size) {
    // print('Painting rectangle...');

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
        // final top = coord[0];
        // final left = coord[1];
        // final bottom = coord[2];
        // final right = coord[3];

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
