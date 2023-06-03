import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipt_to_spreadsheet/Models/spreadsheet_metadata.dart';
import 'package:receipt_to_spreadsheet/Utilities/file_manager.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/text_input_alert.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold.dart';
import 'package:receipt_to_spreadsheet/auth/hash_utility.dart';

class ConnectionSettings extends StatefulWidget {
  const ConnectionSettings({super.key});

  @override
  State<ConnectionSettings> createState() => _ConnectionSettingsState();
}

class _ConnectionSettingsState extends State<ConnectionSettings> {
  late Future<List<SpreadsheetMetadata>> metadataObjects;

  // Has been revealed at least once this session
  bool revealed = false;

  // Toggles obscuring text
  bool textIsHidden = true;

  final String hiddenText = "***************";

  late String ocrKeyText;
  String? lastKeyText;

  @override
  void initState() {
    super.initState();
    metadataObjects = FileManager.readSpreadsheetMetadataFromFile();
    ocrKeyText = hiddenText;
  }

  void _toggleOcrKeyText() async {
    if (textIsHidden) {
      setState(() {
        lastKeyText = ocrKeyText;
        ocrKeyText = hiddenText;
      });
    } else {
      if (lastKeyText == null) {
        final retrievedKey =
            (await SecureStorage.readFromKey(SecureStorageConstants.OCR_KEY))!;
        setState(() {
          lastKeyText = ocrKeyText;
          ocrKeyText = retrievedKey;
        });
      } else {
        setState(() {
          ocrKeyText = lastKeyText!;
          lastKeyText = hiddenText;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptScaffold(
        scaffoldColor: const Color.fromARGB(255, 107, 49, 216),
        children: [
          Container(
            // color: const Color.fromARGB(255, 85, 30, 189),
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 85, 30, 189),
              Color.fromARGB(255, 60, 19, 136),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            padding: const EdgeInsets.all(10),
            height: double.infinity,
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color.fromARGB(255, 107, 49, 216),
                              width: 2)),
                      child: ExpansionTile(
                        title: const Text(
                          "Connected Spreadsheets",
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 107, 49, 216),
                              fontWeight: FontWeight.w500),
                        ),
                        children: [
                          FutureBuilder<List<SpreadsheetMetadata>>(
                            future: metadataObjects,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<SpreadsheetMetadata>>
                                    snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return const Text("Error");
                              } else {
                                List<SpreadsheetMetadata> metadataList =
                                    snapshot.data!;
                                return ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount: metadataList.length + 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == metadataList.length) {
                                        return const ListTile(
                                          title: Text("Connect More"),
                                        );
                                      }
                                      SpreadsheetMetadata metadata =
                                          metadataList[index];
                                      bool canDelete = metadataList.length > 1;
                                      return IntrinsicHeight(
                                          child: ListTile(
                                        visualDensity:
                                            const VisualDensity(vertical: 2),
                                        title: Text(
                                          metadata.sheetTitle,
                                          style: const TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        subtitle: Text(
                                          "Default Worksheet: ${metadata.defaultWorksheet ?? "none"}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                          ),
                                        ),
                                        trailing: IconButton(
                                          disabledColor: Colors.grey,
                                          icon: const Icon(Icons.delete),
                                          onPressed: canDelete ? () {} : null,
                                          color: const Color.fromARGB(
                                              255, 107, 49, 216),
                                        ),
                                      ));
                                    });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: const Color.fromARGB(255, 107, 49, 216),
                                width: 2)),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ExpansionTile(
                            title: const Text("OCR Key:",
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 107, 49, 216),
                                    fontWeight: FontWeight.w500)),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Text(ocrKeyText,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color:
                                              Color.fromARGB(255, 107, 49, 216),
                                        )),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                          iconSize: 20,
                                          onPressed: !textIsHidden
                                              ? () {
                                                  Clipboard.setData(
                                                      ClipboardData(
                                                          text: ocrKeyText));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      duration:
                                                          Duration(seconds: 1),
                                                      content: Center(
                                                        child: Text(
                                                            'Copied to Clipboard.'),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              : null,
                                          icon: const Icon(Icons.content_copy)),
                                      IconButton(
                                          iconSize: 24,
                                          onPressed: revealed
                                              ? () {
                                                  setState(() {
                                                    textIsHidden =
                                                        !textIsHidden;
                                                    print(textIsHidden);
                                                    _toggleOcrKeyText();
                                                  });
                                                }
                                              : () async {
                                                  await _askForPIN()
                                                      .then((result) {
                                                    setState(() {
                                                      revealed = result;
                                                      textIsHidden = !result;
                                                      print(textIsHidden);
                                                      _toggleOcrKeyText();
                                                    });
                                                  });
                                                },
                                          icon: Icon(
                                            textIsHidden
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey.shade700,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                      child: InkWell(
                                        onTap: () {},
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                  color: const Color.fromARGB(
                                                      255, 107, 49, 216),
                                                  width: 2)),
                                          child: const Text(
                                            "Change Key",
                                            style: TextStyle(
                                                fontSize: 15.5,
                                                color: Color.fromARGB(
                                                    255, 107, 49, 216),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ])),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: MaterialButton(
                          onPressed: () {},
                          minWidth: MediaQuery.of(context).size.width * 0.7,
                          color: Colors.white,
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 107, 49, 216)),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ]);
  }

  String? _pinValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter a PIN to reveal key.";
    }

    return "PIN is not valid.";
  }

  Future<bool> _validatePIN(String? value) async {
    if (value == null || value.isEmpty) {
      return false;
    }

    return HashUtility.givenPINIsCorrectPIN(value);
  }

  Future<bool> _askForPIN() async {
    final result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return TextInputAlert(
            title: "PIN:",
            alertColor: Color.fromARGB(255, 107, 49, 216),
            validator: _pinValidator,
            validationContinue: _validatePIN,
          );
        });

    if (result == null) {
      return false;
    }

    return result;
  }
}
