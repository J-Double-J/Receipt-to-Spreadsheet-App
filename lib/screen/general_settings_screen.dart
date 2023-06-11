import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/receipt_alert_box.dart';

class GeneralSettings extends StatefulWidget {
  const GeneralSettings({super.key});

  @override
  State<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends State<GeneralSettings> {
  String _purchaserName = "Josh";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("General Settings")),
      body: Column(children: [
        Container(
            child: Row(
          children: [
            GestureDetector(
              onTap: () async {
                String? inputName = await editPurchaserNameDialog();
                setState(() {
                  _purchaserName = inputName ?? _purchaserName;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: const Text("Purchaser Name:"),
              ),
            ),
            Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.centerLeft,
                child: Text(_purchaserName))
          ],
        ))
      ]),
    );
  }

  Future<String?> editPurchaserNameDialog() async {
    String? inputText;
    return showDialog(
        context: context,
        builder: (context) {
          return ReceiptAlertBox(
            title: "Change Purchaser Name",
            alertColor: Theme.of(context).primaryColor,
            bodyContent: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    inputText = value;
                  },
                  decoration: const InputDecoration(
                      hintText: "Ex: your name",
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purple, width: 2))),
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(null);
                        },
                        child: const Text("Cancel")),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(inputText);
                        },
                        child: const Text("Submit"))
                  ],
                )
              ],
            ),
          );
        });
  }
}
