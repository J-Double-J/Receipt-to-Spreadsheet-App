import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:receipt_to_spreadsheet/Models/expense_data_entry.dart';

// This throws an exception that doesn't break the app. It doesn't seem to want to be caught, so I'm not sure where it is.

class GoogleSheetsProxy {
  static String EMAIL_SERVICE =
      "receipt-to-spreadsheet@receipttospreadsheet.iam.gserviceaccount.com";
  static String? _credentials;
  static GSheets? _gSheets;
  late String _sheetID;

  static late Spreadsheet _spreadsheet;
  static late Worksheet _worksheet;

  static final Completer _completerSetup = Completer();
  static bool _completedSetup = false;

  GoogleSheetsProxy(String sheetID) {
    _sheetID = sheetID;
    try {
      _loadCredentials().then((_) {
        _gSheets ??= GSheets(_credentials);
        _initializeSpreadSheet().then((_) {
          _completerSetup.complete();
          _completedSetup = true;
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadCredentials() async {
    _credentials ??=
        await rootBundle.loadString("lib/auth/google_sheets_secret.json");
  }

  Future<void> _initializeSpreadSheet() async {
    return _gSheets!.spreadsheet(_sheetID).then((spreadsheet) {
      _spreadsheet = spreadsheet;
    });
  }

  // So Google's API is a little odd where you can't actually get your permissions unless you are an editor/owner.
  // So if we can't find ourselves on their sheet, it means that we aren't added OR that we're not an editor.
  Future<bool> hasWritePermission() async {
    final permissions = await _spreadsheet.permissionByEmail(EMAIL_SERVICE);
    if (permissions == null) {
      return false;
    } else {
      if (permissions.role == "writer") {
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> waitForCompleteSetUp() async {
    if (_completedSetup) {
      return;
    } else {
      await _completerSetup.future;
    }
  }

  void setCurrentWorksheet(String worksheet) {
    try {
      _worksheet = _spreadsheet.worksheetByTitle(worksheet)!;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addOCRBoxesToSheet(
      List<MapEntry<String, Decimal>> entries) async {
    List<Map<String, dynamic>> rowEntries = [];
    var date = DateTime.now();
    for (var entry in entries) {
      if (entry.value <= Decimal.zero) {
        continue;
      }

      var expenseEntry = ExpenseDataEntry(
          date: date,
          expenseCode: entry.key,
          cost: entry.value.toString(),
          purchaser: "Josh");

      rowEntries.add(expenseEntry.toJson());
    }

    if (rowEntries.isEmpty) {
      return false;
    } else {
      return addRows(rowEntries);
    }
  }

  Future<bool> addRow(Map<String, dynamic> row) async {
    return _worksheet.values.map.appendRow(row);
  }

  Future<bool> addRows(List<Map<String, dynamic>> rows) async {
    return _worksheet.values.map.appendRows(rows);
  }

  String getSheetTitle() {
    return _spreadsheet.data.properties.title ?? "Untitled";
  }

  List<String> getWorksheetTitles() {
    List<String> worksheetTitles = [];

    for (var worksheet in _spreadsheet.sheets) {
      worksheetTitles.add(worksheet.title);
    }

    return worksheetTitles;
  }
}
