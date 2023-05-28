import 'package:receipt_to_spreadsheet/Proxies/google_sheets_proxy.dart';

class SpreadsheetMetadata {
  late String sheetTitle;
  late String sheetID;
  late List<String> worksheetNames;
  String? defaultWorksheet;

  SpreadsheetMetadata(this.sheetID) {
    var proxy = GoogleSheetsProxy(sheetID);
    proxy.waitForCompleteSetUp().then((_) {
      sheetTitle = proxy.getSheetTitle();
      worksheetNames = proxy.getWorksheetTitles();
    });
  }

  void setDefaultWorksheet(String worksheet) {
    if (worksheetNames.contains(worksheet)) {
      defaultWorksheet = worksheet;
    } else {
      throw ArgumentError.value(worksheet);
    }
  }
}
