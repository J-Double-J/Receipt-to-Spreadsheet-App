import 'package:receipt_to_spreadsheet/Proxies/google_sheets_proxy.dart';

class SpreadsheetMetadata {
  late String sheetTitle;
  late String sheetID;
  late List<String> worksheetNames;
  String? defaultWorksheet;

  SpreadsheetMetadata._create(this.sheetID);
  SpreadsheetMetadata._fromJson(this.sheetTitle, this.sheetID,
      this.worksheetNames, this.defaultWorksheet);

  static Future<SpreadsheetMetadata> create(String sheetID) async {
    final instance = SpreadsheetMetadata._create(sheetID);

    await instance._initialize(sheetID);

    return instance;
  }

  factory SpreadsheetMetadata.fromJson(Map<String, dynamic> json) {
    return SpreadsheetMetadata._fromJson(
        json["sheetTitle"],
        json["sheetID"],
        json["worksheetNames"].toString().split(',').toList(),
        json["defaultWorksheet"]);
  }

  Future<void> _initialize(String sheetID) async {
    var proxy = GoogleSheetsProxy(sheetID);
    await proxy.waitForCompleteSetUp().then((_) {
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

  Map<String, dynamic> toJson() {
    return {
      "sheetTitle": sheetTitle,
      "sheetID": sheetID,
      "worksheetNames": worksheetNames.join(','),
      "defaultWorksheet": defaultWorksheet
    };
  }
}
