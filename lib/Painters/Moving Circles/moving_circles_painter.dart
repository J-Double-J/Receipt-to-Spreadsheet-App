import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Painters/Moving%20Circles/circle.dart';

class MovingCirclesPainter extends CustomPainter {
  final List<Circle> circles;
  final double width;
  final double height;

  MovingCirclesPainter(this.circles,
      {required this.width, required this.height});

  @override
  void paint(Canvas canvas, Size size) {
    for (final circle in circles) {
      final paint = Paint()
        ..color = circle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(circle.position.dx * width, circle.position.dy * height),
        circle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(MovingCirclesPainter oldDelegate) {
    return circles != oldDelegate.circles;
  }
}
