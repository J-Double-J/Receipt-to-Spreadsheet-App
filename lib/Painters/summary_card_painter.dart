import 'dart:math';

import 'package:flutter/material.dart';

class SummaryCardPainter extends CustomPainter {
  final double borderRadius;

  SummaryCardPainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint paintPurple = Paint()..color = Colors.purple;
    final Paint paintPink = Paint()..color = Colors.purple;

    // Define the line equation
    double lineEquation(double x) {
      final double xOffset = width / 2;
      final double adjustedX = (x - xOffset - 10)
          .clamp(0, width); // Clamp adjustedX within the valid range
      final double y =
          72 + (-5.010025e-15 - 72) / pow(1 + (adjustedX / 200), 33.9966);
      return y < 0 ? 0 : y;
    }

    // Create the rounded rectangle path
    final Path roundedRect = Path()
      ..addRRect(RRect.fromLTRBR(
        0,
        0,
        width,
        height,
        Radius.circular(borderRadius),
      ));

    // Clip the canvas to the rounded rectangle path
    canvas.clipPath(roundedRect);

    // Draw the left side (purple)
    final Path pathLeft = Path();
    pathLeft.moveTo(0, height);
    for (double x = 0; x <= width; x += 1) {
      final double y = lineEquation(x);
      pathLeft.lineTo(x, height - y);
    }
    pathLeft.lineTo(width, height);
    canvas.drawPath(pathLeft, paintPurple);

    // Draw the right side (pink)
    final Path pathRight = Path();
    pathRight.moveTo(width, height);
    for (double x = width; x >= 0; x -= 1) {
      final double y = lineEquation(x);
      pathRight.lineTo(x, height - y);
    }
    pathRight.lineTo(0, height);
    canvas.drawPath(pathRight, paintPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
