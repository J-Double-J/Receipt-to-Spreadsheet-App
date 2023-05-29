import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Models/spreadsheet_metadata.dart';

import '../../../Utilities/file_manager.dart';

class FinalizingSetup extends StatefulWidget {
  final void Function() callback;
  final SpreadsheetMetadata? spreadsheetMetadata;
  const FinalizingSetup(
      {super.key, required this.callback, this.spreadsheetMetadata});

  @override
  State<FinalizingSetup> createState() => _FinalizingSetupState();
}

class _FinalizingSetupState extends State<FinalizingSetup> {
  @override
  Widget build(BuildContext context) {
    executeFinalSetup();
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.18,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Text(
                  "We're finalizing a few more things...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10,
                ),
                CircularProgressIndicator(
                  color: Colors.white,
                )
              ]),
        ),
      ),
    );
  }

  void executeFinalSetup() async {
    print(widget.spreadsheetMetadata);
    if (widget.spreadsheetMetadata != null) {
      FileManager.saveSpreadsheetMetadata([widget.spreadsheetMetadata!])
          .then((_) {
        widget.callback();
      });
    }
  }
}
