import 'package:flutter/material.dart';

class StartUserSetupIntroduction extends StatefulWidget {
  final void Function() callback;
  const StartUserSetupIntroduction({super.key, required this.callback});

  @override
  State<StartUserSetupIntroduction> createState() =>
      _StartUserSetupIntroductionState();
}

class _StartUserSetupIntroductionState
    extends State<StartUserSetupIntroduction> {
  String introduction =
      "Hello, it looks like you're a new user! Thank you for installing this tool! Before you can use this tool there is some setup you must do. Don't worry though, we'll step you through it. This will take 5-10 minutes to complete.";
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Container(
        padding: const EdgeInsets.all(15),
        height: MediaQuery.of(context).size.height * 0.65,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const Text(
            "Welcome to Easy Receipt Tracking!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w500),
          ),
          const Text(
            "Before you can get started scanning your receipts, we'll need some information from you.",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400),
          ),
          const Text("This will take about 5-10 minutes to complete.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w400)),
          MaterialButton(
            color: Colors.white,
            onPressed: () {
              widget.callback();
            },
            minWidth: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "Let's Get Started!",
              style: TextStyle(
                  color: Color.fromARGB(255, 107, 49, 216),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          )
        ]),
      )),
    );
  }
}
