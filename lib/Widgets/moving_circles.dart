import 'package:flutter/material.dart';
import 'dart:math';

import '../Painters/Moving Circles/circle.dart';
import '../Painters/Moving Circles/moving_circles_painter.dart';

class MovingCirclesWidget extends StatefulWidget {
  Widget? child;

  MovingCirclesWidget({super.key, this.child});

  @override
  _MovingCirclesWidgetState createState() => _MovingCirclesWidgetState();
}

class _MovingCirclesWidgetState extends State<MovingCirclesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  final List<Circle> _circles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..addListener(() {
        setState(() {
          for (final circle in _circles) {
            circle.updatePosition();
          }
        });
      });

    _addCircles();
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _addCircles() {
    const screenWidth = 1.0; // Width of the screen
    const screenHeight = 1.0; // Height of the screen

    double normalizedSpeed = 0.0012;

    // Define the positions for each fourth of the screen
    const positions = [
      Offset(screenWidth / 4, screenHeight / 4), // Top left
      Offset(screenWidth * 3 / 4, screenHeight / 4), // Top right
      Offset(screenWidth / 4, screenHeight * 3 / 4), // Bottom left
      Offset(screenWidth * 3 / 4, screenHeight * 3 / 4), // Bottom right
    ];

    List<int> selectedAngles = [69, 250, 112, 24];
    List<double> circleRadiuses = [100, 170, 90, 120];
    for (var i = 0; i < 4; i++) {
      final position = positions[i];

      double radius = circleRadiuses[i];

      final color = Colors.pink.withOpacity(0.5);

      Offset velocity = Offset(
          cos(selectedAngles[i] * pi / 180) * normalizedSpeed,
          sin(selectedAngles[i] * pi / 180) * normalizedSpeed);

      final circle = Circle(position, radius, color, velocity);
      _circles.add(circle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return CustomPaint(
            painter: MovingCirclesPainter(_circles,
                width: constraints.maxWidth, height: constraints.maxHeight),
            isComplex: true,
            willChange: true,
            child: widget.child);
      },
    );
  }
}
