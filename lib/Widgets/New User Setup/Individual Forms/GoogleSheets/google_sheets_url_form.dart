import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Utilities/google_sheets_id_extractor.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../../../../Utilities/secure_storage.dart';
import '../../../../Utilities/common.dart';

class GoogleSheetsURLForm extends StatefulWidget {
  final void Function() callback;
  final Future<void> Function(String) setSheetIDCallback;
  const GoogleSheetsURLForm(
      {super.key, required this.callback, required this.setSheetIDCallback});

  @override
  State<GoogleSheetsURLForm> createState() => _GoogleSheetsURLFormState();
}

class _GoogleSheetsURLFormState extends State<GoogleSheetsURLForm> {
  final _formKey = GlobalKey<FormState>();
  final _urlController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "What is the URL of the Google Spreadsheet we should update?",
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
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                            decoration: InputDecoration(
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.pink),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText:
                                    "https://docs.google.com/spreadsheets/d/exampleIDHere/",
                                hintStyle:
                                    TextStyle(color: Colors.grey.shade300),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0)),
                                errorStyle:
                                    const TextStyle(color: Colors.white)),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter a URL";
                              }

                              if (GoogleSheetsIDExtractor.isGoogleSheetsURL(
                                  value)) {
                                String? id =
                                    GoogleSheetsIDExtractor.extractIDFromURL(
                                        value);
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
                          Common.closeKeyboard(context);
                          setState(() {
                            isLoading = true;
                          });
                          if (_formKey.currentState!.validate()) {
                            String id =
                                GoogleSheetsIDExtractor.extractIDFromURL(
                                    _urlController.text)!;
                            SecureStorage.writeToKey(
                                SecureStorageConstants.SPREADSHEET_IDS, id);
                            widget.setSheetIDCallback(id).then((_) {
                              setState(() {
                                isLoading = false;
                              });
                              widget.callback();
                            });
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                        minWidth: MediaQuery.of(context).size.width * 0.7,
                        color: Colors.white,
                        child: const Text("Continue",
                            style: TextStyle(
                                color: Color.fromARGB(255, 107, 49, 216),
                                fontSize: 20,
                                fontWeight: FontWeight.w500)))
                  ]),
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
