// To parse this JSON data, do
//
//     final ocrResponse = ocrResponseFromJson(jsonString);

import 'dart:convert';

OcrResponse ocrResponseFromJson(String str) =>
    OcrResponse.fromJson(json.decode(str));

String ocrResponseToJson(OcrResponse data) => json.encode(data.toJson());

class OcrResponse {
  OcrResponse({
    required this.parsedResults,
    required this.ocrExitCode,
    required this.isErroredOnProcessing,
    required this.processingTimeInMilliseconds,
    required this.searchablePdfurl,
  });

  List<ParsedResult> parsedResults;
  int ocrExitCode;
  bool isErroredOnProcessing;
  String processingTimeInMilliseconds;
  String searchablePdfurl;

  factory OcrResponse.fromJson(Map<String, dynamic> json) => OcrResponse(
        parsedResults: List<ParsedResult>.from(
            json["ParsedResults"].map((x) => ParsedResult.fromJson(x))),
        ocrExitCode: json["OCRExitCode"],
        isErroredOnProcessing: json["IsErroredOnProcessing"],
        processingTimeInMilliseconds: json["ProcessingTimeInMilliseconds"],
        searchablePdfurl: json["SearchablePDFURL"],
      );

  Map<String, dynamic> toJson() => {
        "ParsedResults":
            List<dynamic>.from(parsedResults.map((x) => x.toJson())),
        "OCRExitCode": ocrExitCode,
        "IsErroredOnProcessing": isErroredOnProcessing,
        "ProcessingTimeInMilliseconds": processingTimeInMilliseconds,
        "SearchablePDFURL": searchablePdfurl,
      };
}

class ParsedResult {
  ParsedResult({
    required this.textOverlay,
    required this.textOrientation,
    required this.fileParseExitCode,
    required this.parsedText,
    required this.errorMessage,
    required this.errorDetails,
  });

  TextOverlay textOverlay;
  String textOrientation;
  int fileParseExitCode;
  String parsedText;
  String errorMessage;
  String errorDetails;

  factory ParsedResult.fromJson(Map<String, dynamic> json) => ParsedResult(
        textOverlay: TextOverlay.fromJson(json["TextOverlay"]),
        textOrientation: json["TextOrientation"],
        fileParseExitCode: json["FileParseExitCode"],
        parsedText: json["ParsedText"],
        errorMessage: json["ErrorMessage"],
        errorDetails: json["ErrorDetails"],
      );

  Map<String, dynamic> toJson() => {
        "TextOverlay": textOverlay.toJson(),
        "TextOrientation": textOrientation,
        "FileParseExitCode": fileParseExitCode,
        "ParsedText": parsedText,
        "ErrorMessage": errorMessage,
        "ErrorDetails": errorDetails,
      };
}

class TextOverlay {
  TextOverlay({
    required this.lines,
    required this.hasOverlay,
  });

  List<Line> lines;
  bool hasOverlay;

  factory TextOverlay.fromJson(Map<String, dynamic> json) => TextOverlay(
        lines: List<Line>.from(json["Lines"].map((x) => Line.fromJson(x))),
        hasOverlay: json["HasOverlay"],
      );

  Map<String, dynamic> toJson() => {
        "Lines": List<dynamic>.from(lines.map((x) => x.toJson())),
        "HasOverlay": hasOverlay,
      };
}

class Line {
  Line({
    required this.lineText,
    required this.words,
    required this.maxHeight,
    required this.minTop,
  });

  String lineText;
  List<Word> words;
  double maxHeight;
  double minTop;

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        lineText: json["LineText"],
        words: List<Word>.from(json["Words"].map((x) => Word.fromJson(x))),
        maxHeight: json["MaxHeight"],
        minTop: json["MinTop"],
      );

  Map<String, dynamic> toJson() => {
        "LineText": lineText,
        "Words": List<dynamic>.from(words.map((x) => x.toJson())),
        "MaxHeight": maxHeight,
        "MinTop": minTop,
      };
}

class Word {
  Word({
    required this.wordText,
    required this.left,
    required this.top,
    required this.height,
    required this.width,
  });

  String wordText;
  double left;
  double top;
  double height;
  double width;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
        wordText: json["WordText"],
        left: json["Left"],
        top: json["Top"],
        height: json["Height"],
        width: json["Width"],
      );

  Map<String, dynamic> toJson() => {
        "WordText": wordText,
        "Left": left,
        "Top": top,
        "Height": height,
        "Width": width,
      };
}
