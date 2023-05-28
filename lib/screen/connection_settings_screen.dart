import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Models/spreadsheet_metadata.dart';
import 'package:receipt_to_spreadsheet/Utilities/file_manager.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold.dart';

class ConnectionSettings extends StatefulWidget {
  const ConnectionSettings({super.key});

  @override
  State<ConnectionSettings> createState() => _ConnectionSettingsState();
}

class _ConnectionSettingsState extends State<ConnectionSettings> {
  late Future<List<SpreadsheetMetadata>> metadataObjects;

  @override
  void initState() {
    super.initState();
    metadataObjects = FileManager.readSpreadsheetMetadataFromFile();
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
}
