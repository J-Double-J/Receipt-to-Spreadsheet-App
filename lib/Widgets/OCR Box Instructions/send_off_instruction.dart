import 'package:flutter/material.dart';

class SendOffInstruction extends StatefulWidget {
  const SendOffInstruction({super.key});

  @override
  State<SendOffInstruction> createState() => _SendOffInstructionState();
}

class _SendOffInstructionState extends State<SendOffInstruction>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween(begin: -0.03, end: 0.03).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sendoff!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 24),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              RotationTransition(
                turns: _animation,
                child: Icon(
                  Icons.rocket_launch,
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "After selecting the prices to forward to the spreadsheet, you will be directed to a screen where you can review your information.",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Here, you'll find a comprehensive breakdown of prices categorized for your convenience. You can also view the specific spreadsheet that will receive this data and identify who is responsible for payment.",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
                maxLines: null,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Once you're ready to go, you can tap submit and your spreadsheet will be updated promptly with your scanned receipt!",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
                maxLines: null,
                textAlign: TextAlign.center,
              )
            ],
          ),
        )),
      ),
    );
  }
}
