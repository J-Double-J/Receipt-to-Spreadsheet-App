import 'package:flutter/material.dart';

class MovingArrowWidget extends StatefulWidget {
  Color? color;
  double? verticalHeight;
  String? floatingText;
  TextStyle? textStyle;
  MovingArrowWidget(
      {super.key,
      this.color,
      this.verticalHeight,
      this.floatingText,
      this.textStyle});

  @override
  _MovingArrowWidgetState createState() => _MovingArrowWidgetState();
}

class _MovingArrowWidgetState extends State<MovingArrowWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: -0.5, end: 0.5).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: (_animation.value + 1.0) / 2.0,
          child: Transform.translate(
            offset: Offset(0, (widget.verticalHeight ?? 50) * _animation.value),
            child: Column(
              children: [
                widget.floatingText != null
                    ? Text(
                        widget.floatingText!,
                        style: widget.textStyle ??
                            const TextStyle(color: Colors.white),
                      )
                    : Container(),
                Icon(
                  Icons.arrow_downward,
                  size: 48,
                  color: widget.color ?? Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
