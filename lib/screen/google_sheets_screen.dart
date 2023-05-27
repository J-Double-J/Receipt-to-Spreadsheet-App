import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../Proxies/google_sheets_proxy.dart';
import '../Utilities/secure_storage.dart';

class SheetsScreen extends StatefulWidget {
  const SheetsScreen({super.key});

  @override
  State<SheetsScreen> createState() => _SheetsScreenState();
}

class _SheetsScreenState extends State<SheetsScreen> {
  @override
  void initState() async {
    // TODO: implement initState
    super.initState();
    GoogleSheetsProxy((await SecureStorage.readFromKey(
        SecureStorageConstants.SPREADSHEET_IDS))!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}
