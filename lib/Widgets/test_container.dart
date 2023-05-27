// This is just for routing to a basic container so that I can see what changes I am making on hot reload.

import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/slide_information_alert.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCR%20Box%20Instructions/long_press_instruction.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCR%20Box%20Instructions/send_off_instruction.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCR%20Box%20Instructions/single_tap_instruction.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCR%20Box%20Instructions/total_instruction.dart';

class TestContainer extends StatelessWidget {
  TestContainer({super.key});

  List<Widget> containers = [
    const SingleTapInstruction(),
    const LongPressInstruction(),
    const TotalInstruction(),
    const SendOffInstruction()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.purple,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SlideInformationAlert(
                    content: containers,
                  );
                });
          },
        ),
      ),
    );
  }
}
