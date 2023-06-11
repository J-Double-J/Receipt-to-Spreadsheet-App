import 'package:flutter/material.dart';

import 'moving_circles.dart';

class SingularFormDisplay extends StatefulWidget {
  final Widget form;
  const SingularFormDisplay({super.key, required this.form});

  @override
  State<SingularFormDisplay> createState() => _SingularFormDisplayState();
}

class _SingularFormDisplayState extends State<SingularFormDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(255, 107, 49, 216),
        child: MovingCirclesWidget(
          child: Center(child: widget.form),
        ),
      ),
    );
  }
}
