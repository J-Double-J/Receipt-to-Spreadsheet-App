import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Models/spreadsheet_metadata.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../../../Utilities/file_manager.dart';
import '../../../Utilities/secure_storage.dart';

class FinalizingSetup extends StatefulWidget {
  final void Function() callback;
  const FinalizingSetup({super.key, required this.callback});

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
    // There shouldn't be more than one at this point, but this key should be holding a list.
    List<String>? idsFound = await SecureStorage.readListFromKey(
        SecureStorageConstants.SPREADSHEET_IDS);

    if (idsFound == null) {
      return;
    }

    List<SpreadsheetMetadata> metadataObjects = [];
    for (var id in idsFound) {
      metadataObjects.add(await SpreadsheetMetadata.create(id));
    }

    FileManager.saveSpreadsheetMetadata(metadataObjects).then((_) {
      widget.callback();
    });
  }
}
