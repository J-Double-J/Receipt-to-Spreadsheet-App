import 'package:flutter/material.dart';

class Circle {
  Offset position;
  double radius;
  Color color;
  Offset velocity;

  Circle(this.position, this.radius, this.color, this.velocity);
  // : velocity = const Offset(0.001, 0.001);

  void updatePosition() {
    position += velocity;

    if (position.dx < 0 || position.dx > 1) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy < 0 || position.dy > 1) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }
  }
}
