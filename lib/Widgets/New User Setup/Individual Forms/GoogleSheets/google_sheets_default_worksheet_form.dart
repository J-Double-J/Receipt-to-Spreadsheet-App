import 'package:flutter/material.dart';

import '../../../../Models/spreadsheet_metadata.dart';

class DefaultWorksheetForm extends StatefulWidget {
  final SpreadsheetMetadata? sheetMetadata;
  final void Function() callback;

  const DefaultWorksheetForm(
      {super.key, required this.sheetMetadata, required this.callback});

  @override
  State<DefaultWorksheetForm> createState() => _DefaultWorksheetFormState();
}

class _DefaultWorksheetFormState extends State<DefaultWorksheetForm> {
  late String _defaultWorksheet;
  late List<String> worksheets;

  @override
  void initState() {
    super.initState();
    worksheets = widget.sheetMetadata?.worksheetNames ?? [];
    if (worksheets.isEmpty) {
      _defaultWorksheet = "None Found";
    } else {
      _defaultWorksheet = worksheets.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.55,
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  "Which Worksheet would you like us to document to by default?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  "You can change this later.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.deepPurple)),
                    width: MediaQuery.of(context).size.width * 0.8,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: Center(
                      child: DropdownButton(
                        underline: Container(),
                        value: _defaultWorksheet,
                        onChanged: (value) {
                          setState(() {
                            _defaultWorksheet = value!;
                          });
                        },
                        items: worksheets
                            .map<DropdownMenuItem<String>>((worksheet) {
                          return DropdownMenuItem<String>(
                            value: worksheet,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width *
                                  0.65, // Set the desired width for the menu item
                              child: Text(worksheet),
                            ),
                          );
                        }).toList(),
                      ),
                    )),
                MaterialButton(
                    onPressed: () {
                      widget.sheetMetadata!.defaultWorksheet =
                          _defaultWorksheet;
                      widget.callback();
                    },
                    minWidth: MediaQuery.of(context).size.width * 0.7,
                    color: Colors.white,
                    child: const Text("Continue",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 107, 49, 216),
                            fontWeight: FontWeight.w500)))
              ]),
        ),
      ),
    );
  }
}
