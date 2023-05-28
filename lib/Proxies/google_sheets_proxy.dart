import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:receipt_to_spreadsheet/Models/expense_data_entry.dart';

class GoogleSheetsProxy {
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
          _completedSetup = true;
          _completerSetup.complete();
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
      _worksheet = _spreadsheet.worksheetByTitle("Expenses")!;
    });
  }

  Future<void> waitForCompleteSetUp() async {
    if (_completedSetup) {
      return;
    } else {
      await _completerSetup.future;
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
