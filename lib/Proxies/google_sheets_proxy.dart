import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:receipt_to_spreadsheet/Models/expense_data_entry.dart';

// TODO: Clean up file
class GoogleSheetsProxy {
  static late final String _credentials;
  static late final GSheets _gSheets;
  late String _sheetID/*= "19HvkVE8m4Js9riPiIRbd6TH1lKIxHTqg-QFWPGU8tkk"*/;

  static late Spreadsheet _spreadsheet;
  static late Worksheet _worksheet;

  static final Completer _completerSetup = Completer();
  static bool _completedSetup = false;

  // static final GoogleSheetsProxy _proxy = GoogleSheetsProxy._internal();

  // factory GoogleSheetsProxy() {
  //   return _proxy;
  // }

  GoogleSheetsProxy(String sheetID) {
    _sheetID = sheetID;
    try {
      _loadCredentials().then((_) {
        _gSheets = GSheets(_credentials);
        _initializeSpreadSheet().then((_) {
          // test();
          _completedSetup = true;
          _completerSetup.complete();
        });
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _loadCredentials() async {
    _credentials =
        await rootBundle.loadString("lib/auth/google_sheets_secret.json");
  }

  Future<void> _initializeSpreadSheet() async {
    return _gSheets.spreadsheet(_sheetID).then((spreadsheet) {
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

  // // TODO: Remove old method
  // Future<bool> addOCRBoxesToSheet(Map<String, Decimal> entries) async {
  //   List<Map<String, dynamic>> rowEntries = [];
  //   var date = DateTime.now();
  //   entries.forEach((key, value) {
  //     if (value <= Decimal.zero) {
  //       return;
  //     }

  //     var expenseEntry = ExpenseDataEntry(
  //         date: date,
  //         expenseCode: key,
  //         cost: value.toString(),
  //         purchaser: "Josh");

  //     rowEntries.add(expenseEntry.toJson());
  //   });

  //   if (rowEntries.isEmpty) {
  //     return false;
  //   } else {
  //     return addRows(rowEntries);
  //   }
  // }

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
}
