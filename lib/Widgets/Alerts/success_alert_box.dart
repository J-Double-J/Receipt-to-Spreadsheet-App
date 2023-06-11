import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/receipt_alert_box.dart';

class SuccessAlertBox extends StatelessWidget {
  const SuccessAlertBox({super.key});

  @override
  Widget build(BuildContext context) {
    return ReceiptAlertBox(
      title: "Success",
      alertColor: Colors.green,
      bodyContent: Column(
        children: [
          Image.asset(
            "assets/images/success.png",
            height: MediaQuery.of(context).size.height * 0.12,
            width: MediaQuery.of(context).size.height * 0.12,
          ),
          const Text(
            "Receipt was successfully transcribed to Sheets!",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 39, 117, 42)),
          )
        ],
      ),
    );
  }
}
