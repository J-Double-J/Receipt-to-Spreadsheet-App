import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Painters/dashed-rect-painted.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final Color? color;
  final double strokeWidth;
  final double gapWidth;
  final double dashWidth;

  const DashedBorderContainer(
      {super.key,
      required this.child,
      this.color,
      this.strokeWidth = 1.0,
      this.gapWidth = 5.0,
      this.dashWidth = 5.0});

  @override
  Widget build(BuildContext context) {
    //Theme.of(context).primaryColor
    return CustomPaint(
      painter: DashedRectPainter(
          color: color ?? Theme.of(context).primaryColor,
          strokeWidth: strokeWidth,
          gapWidth: gapWidth,
          dashWidth: dashWidth,
          cornerRadius: 5),
      child: Padding(
        padding: EdgeInsets.all(strokeWidth),
        child: Container(
          child: child,
        ),
      ),
    );
  }
}
