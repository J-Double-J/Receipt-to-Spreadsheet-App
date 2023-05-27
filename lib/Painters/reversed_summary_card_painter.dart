import 'dart:math';

import 'package:flutter/material.dart';

class SummaryCardPainterReversed extends CustomPainter {
  final double borderRadius;
  final double extension;

  SummaryCardPainterReversed(
      {required this.borderRadius, this.extension = 10.0});

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint paintPurple = Paint()
      ..color = const Color.fromARGB(255, 107, 49, 216);
    final Paint paintPink = Paint()
      ..color = const Color.fromARGB(255, 107, 49, 216);

    // // Define the line equation
    // double lineEquation(double x) {
    //   final double xOffset = width / 2;
    //   final double adjustedX = x - 150;
    //   final double y = 4.918021e-15 +
    //       (72 - 4.918021e-15) / pow(1 + (adjustedX / 200), 56.40272);
    //   return y < 0 ? 0 : y;
    // }

    double lineEquation(double x) {
      final double xOffset = width / 2;
      final double adjustedX = x - xOffset + 10;
      const double xMin = 0; // Minimum x value for the valid range
      final double xMax = width; // Maximum x value for the valid range
      final double clampedX =
          adjustedX.clamp(xMin, xMax); // Clamp adjustedX to the valid range
      final double y = 4.918021e-15 +
          (72 - 4.918021e-15) / pow(1 + (clampedX / 200), 56.40272);
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
    final double extensionOffset = extension * (width / (width + extension));
    final double extendedWidth = width + extensionOffset;

    pathRight.moveTo(width + extensionOffset, height);
    for (double x = extendedWidth; x >= 0; x -= 1) {
      final double y = lineEquation(x);
      pathRight.lineTo(x, height - y);
    }
    pathRight.lineTo(0, height);
    canvas.drawPath(pathRight, paintPink);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
