import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../Models/spreadsheet_metadata.dart';

class FileManager {
  static String metadataFileName = "Spreadsheet_Metadata_JSON";

  static Future<void> saveSpreadsheetMetadata(
      List<SpreadsheetMetadata> metadataObjects) async {
    var jsonString = jsonEncode(
        metadataObjects.map((metadata) => metadata.toJson()).toList());
    Directory appDir = await getApplicationDocumentsDirectory();
    File file = File('${appDir.path}/$metadataFileName');

    List<int> jsonBytes = utf8.encode(jsonString);

    await file.writeAsBytes(jsonBytes);

    return Future.value();
  }

  static Future<List<SpreadsheetMetadata>>
      readSpreadsheetMetadataFromFile() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    File file = File('${appDir.path}/$metadataFileName');

    List<int> fileBytes = await file.readAsBytes();

    String jsonString = utf8.decode(fileBytes);

    List<dynamic> jsonList = jsonDecode(jsonString);
    List<SpreadsheetMetadata> metadataObjects =
        jsonList.map((json) => SpreadsheetMetadata.fromJson(json)).toList();

    return metadataObjects;
  }
}
