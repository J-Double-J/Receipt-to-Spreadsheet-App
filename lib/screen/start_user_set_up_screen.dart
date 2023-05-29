import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/alert_box.dart';
import 'package:receipt_to_spreadsheet/Widgets/New%20User%20Setup/gather_information_form_screen.dart';

class StartUserSetup extends StatefulWidget {
  const StartUserSetup({super.key});

  @override
  State<StartUserSetup> createState() => _StartUserSetupState();
}

class _StartUserSetupState extends State<StartUserSetup> {
  String introduction =
      "Hello, it looks like you're a new user! Thank you for installing this tool! Before you can use this tool there is some setup you must do. Don't worry though, we'll step you through it. This will take 5-10 minutes to complete.";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          color: Colors.black.withAlpha(125),
          child: RecieptAlertBox(
            title: "Welcome",
            bodyContent: Container(
                child: Column(
              children: [
                Text(
                  introduction,
                  style: const TextStyle(fontSize: 18),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GatherInformationForm()));
                    },
                    color: Colors.purple,
                    child: const Text(
                      "Let's Begin!",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
          ),
        ));
  }
}
