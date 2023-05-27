import 'package:flutter/material.dart';

// This code is courtesy of ChatGPT
class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gapWidth;
  final double dashWidth;
  final double cornerRadius;

  DashedRectPainter(
      {required this.color,
      required this.strokeWidth,
      required this.gapWidth,
      required this.dashWidth,
      this.cornerRadius = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final dashCount = (size.width / (gapWidth + dashWidth)).floor();

    var startX = 0.0;
    var endX = 0.0;
    for (var i = 0; i < dashCount; i++) {
      startX = i * (dashWidth + gapWidth);
      endX = startX + dashWidth;
      canvas.drawLine(Offset(startX, 0.0), Offset(endX, 0.0), paint);
      canvas.drawLine(
          Offset(startX, size.height), Offset(endX, size.height), paint);
    }

    final dashHeightCount = (size.height / (gapWidth + dashWidth)).floor();

    var startY = 0.0;
    var endY = 0.0;
    for (var i = 0; i < dashHeightCount; i++) {
      startY = i * (dashWidth + gapWidth);
      endY = startY + dashWidth;
      canvas.drawLine(Offset(0.0, startY), Offset(0.0, endY), paint);
      canvas.drawLine(
          Offset(size.width, startY), Offset(size.width, endY), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
