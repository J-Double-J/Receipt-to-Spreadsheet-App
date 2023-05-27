import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Utilities/google_sheets_id_extractor.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../../../Utilities/secure_storage.dart';

class GoogleSheetsURLForm extends StatefulWidget {
  final void Function() callback;
  const GoogleSheetsURLForm({super.key, required this.callback});

  @override
  State<GoogleSheetsURLForm> createState() => _GoogleSheetsURLFormState();
}

class _GoogleSheetsURLFormState extends State<GoogleSheetsURLForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.5,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Please copy and paste the URL of your Google Spreadsheet here",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextFormField(
                        controller: _urlController,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                            errorBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.pink),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText:
                                "https://docs.google.com/spreadsheets/d/exampleIDHere/",
                            hintStyle: TextStyle(color: Colors.grey.shade300),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                            errorStyle: const TextStyle(color: Colors.white)),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a URL";
                          }

                          if (GoogleSheetsIDExtractor.isGoogleSheetsURL(
                              value)) {
                            String? id =
                                GoogleSheetsIDExtractor.extractIDFromURL(value);
                            if (id != null) {
                              return null;
                            } else {
                              return "Please make sure to include the full link to your specific spreadsheet.";
                            }
                          } else {
                            return "Please use a URL that is a Google Spreadsheets link";
                          }
                        },
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print(_urlController.text);

                        String id = GoogleSheetsIDExtractor.extractIDFromURL(
                            _urlController.text)!;
                        print(id);
                        SecureStorage.writeToKey(
                            SecureStorageConstants.SPREADSHEET_IDS, id);
                        widget.callback();
                      }
                    },
                    color: Colors.white,
                    child: const Text("Continue",
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.w700)))
              ]),
        ),
      ),
    );
  }
}
