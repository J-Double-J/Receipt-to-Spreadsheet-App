import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../Utilities/secure_storage.dart';
import '../ocr_response.dart';

class OCRProxy {
  static Future<bool> validateOCRKey(String key) async {
    const String uri = "https://api.ocr.space/parse/image";

    var request = http.MultipartRequest('POST', Uri.parse(uri));
    request.headers.addAll({"apikey": key});

    // TODO: Change it to not be hardcoded path!
    request.files.add(http.MultipartFile.fromBytes(
        "file",
        (await rootBundle.load("assets/images/test-receipt.jpg"))
            .buffer
            .asUint8List(),
        filename: "test-receipt.jpg"));
    request.fields.addAll({
      'scale': 'true',
      'isTable': 'true',
      'OCREngine': '2',
      'language': 'eng',
      'filetype': path.extension("assets/images/test-receipt.jpg").substring(1),
    });

    var response = await request.send();

    if (response.statusCode != 403) {
      return true;
    } else {
      return false;
    }
  }

  static Future<OcrResponse> scanReceipt(File image) async {
    const String uri = "https://api.ocr.space/parse/image";

    var request = http.MultipartRequest('POST', Uri.parse(uri));
    String? key =
        await SecureStorage.readFromKey(SecureStorageConstants.OCR_KEY);

    if (key == null) {
      throw StateError("OCR Key not stored");
    }
    request.headers.addAll({"apikey": key});

    // TODO: Change it to not be hardcoded path!
    request.files.add(http.MultipartFile.fromBytes(
        "file",
        (await rootBundle.load("assets/images/bbyRec.jpg"))
            .buffer
            .asUint8List(),
        filename: "bbyRec.jpg"));
    request.fields.addAll({
      'scale': 'true',
      'isTable': 'true',
      'OCREngine': '2',
      'language': 'eng',
      'filetype': path.extension(image.path).substring(1),
    });

    var response = await request.send();
    var responseResult = await http.Response.fromStream(response);

    return ocrResponseFromJson(responseResult.body);
  }
}
