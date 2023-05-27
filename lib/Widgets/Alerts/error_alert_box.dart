import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/alert_box.dart';

class ErrorAlertBox extends StatelessWidget {
  final String errorMessage;
  final List<Widget>? buttons;

  const ErrorAlertBox({super.key, required this.errorMessage, this.buttons});

  @override
  Widget build(BuildContext context) {
    return RecieptAlertBox(
      title: "Error",
      alertColor: Colors.red,
      bodyContent: Column(children: [
        Image.asset(
          "assets/images/error.png",
          height: MediaQuery.of(context).size.height * 0.12,
          width: MediaQuery.of(context).size.height * 0.12,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(0, 8, 0, 18),
          child: Text(
            "Error encountered: $errorMessage",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color.fromARGB(255, 187, 42, 32),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [...?buttons],
        )
      ]),
    );
  }
}
