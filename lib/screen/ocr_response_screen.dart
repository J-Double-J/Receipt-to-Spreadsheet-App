import 'dart:async';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:receipt_to_spreadsheet/Models/ocr_box_data.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/slide_information_alert.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCR%20Box%20Instructions/color_guide.instruction.dart';
import 'package:receipt_to_spreadsheet/Widgets/OCRBox.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold_toggle_appbar.dart';
import 'package:receipt_to_spreadsheet/screen/spreadsheet_submission_summary_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/image_dimensions.dart';
import '../Widgets/Alerts/error_alert_box.dart';
import '../Widgets/OCR Box Instructions/long_press_instruction.dart';
import '../Widgets/OCR Box Instructions/send_off_instruction.dart';
import '../Widgets/OCR Box Instructions/single_tap_instruction.dart';
import '../Widgets/OCR Box Instructions/total_instruction.dart';
import '../ocr_response.dart';

Future<OcrResponse> scanReceipt(File image) async {
  const String uri = "https://api.ocr.space/parse/image";

  var request = http.MultipartRequest('POST', Uri.parse(uri));
  String? key = await SecureStorage.readFromKey(SecureStorageConstants.OCR_KEY);

  if (key == null) {
    throw StateError("OCR Key is not set.");
  }
  request.headers.addAll({"apikey": key});

  // TODO: Change it to not be hardcoded path!
  request.files.add(http.MultipartFile.fromBytes("file",
      (await rootBundle.load("assets/images/bbyRec.jpg")).buffer.asUint8List(),
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

class OcrResponseScreen extends StatefulWidget {
  const OcrResponseScreen(this.file, {super.key});
  final File file;

  @override
  State<OcrResponseScreen> createState() => _OcrResponseScreenState();
}

class _OcrResponseScreenState extends State<OcrResponseScreen> {
  // late Future<OcrResponse> ocrResults;
  late Future<List<dynamic>> futureObjects;
  List<OCRBox> createdBoxes = [];
  double _scale = 1.0;
  bool _showAppBar = true;
  List<String> categories = [];

  @override
  void initState() {
    super.initState();
    // ocrResults = scanReceipt(widget.file);
    futureObjects = initBuilder(widget.file);
    _loadCategories();
    _showInstructionsIfFirstTime();
  }

  void _loadCategories() async {
    await SecureStorage.readListFromKey(SecureStorageConstants.CATEGORIES)
        .then((value) {
      setState(() {
        categories = value!;
      });
    });
  }

  void _showInstructionsIfFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool needsInstructions = prefs.getBool('needsInstructions') ?? true;

    if (needsInstructions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(seconds: 2)).then((_) async {
          _showInstructions(context, true);
        });
      });
    }
  }

  void _showInstructions(BuildContext context, bool isFirstTime) async {
    List<Widget> instructions = [
      const ColorGuideInstruction(),
      const SingleTapInstruction(),
      const LongPressInstruction(),
      const TotalInstruction(),
      const SendOffInstruction()
    ];

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SlideInformationAlert(content: instructions);
        });

    // Future.delayed(const Duration(seconds: 2)).then((_) async {

    // });
    if (isFirstTime) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('needsInstructions', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptScaffoldToggleableAppbar(
        // appBar: _showAppBar
        //     ? AppBar(title: const Text("Select Prices to Track"))
        //     : null,
        showAppBar: _showAppBar,
        hasHelp: true,
        helpCallback: () => _showInstructions(context, false),
        resizeToAvoidBottomInset: false,
        children: [
          FutureBuilder<List<dynamic>>(
            future: futureObjects,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final ParsedResult parsedResult =
                    snapshot.data![0].parsedResults[0];
                final ImageDimensions imageDimensions = snapshot.data![1];
                final List<Key> boxKeys = _generateOCRBoxKeys(parsedResult);
                // return Text("Success! ${snapshot.data!.isErroredOnProcessing}");
                return Column(
                  children: [
                    Expanded(
                      /*child: FittedBox(
                      fit: BoxFit.fill, */
                      child: LayoutBuilder(
                          builder: (imageContext, imageConstraints) {
                        return InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 1.0,
                          maxScale: 3,
                          onInteractionUpdate: (details) {
                            setState(() {
                              // if (details.scale != 1.0) {
                              //   _scale = details.scale;
                              // }
                              // if (_scale <= 1.0) {
                              //   _showAppBar = true;
                              // } else {
                              //   _showAppBar = false;
                              // }
                              if (details.scale != 1.0) {
                                return;
                              }
                              _scale = details.scale;
                              _showAppBar = _scale <= 1.0;
                            });
                          },
                          child: Stack(children: [
                            Image.asset('assets/images/bbyRec.jpg'),
                            ..._displayOCRBoxes(
                                boxKeys,
                                parsedResult,
                                imageConstraints,
                                imageDimensions.width,
                                imageDimensions.height),
                          ]),
                        );
                      }),
                      // ),
                    ),
                    MaterialButton(
                        onPressed: () async {
                          var result =
                              getAndVerifyOCRBoxes(createdBoxes, context);
                          if (result != null) {
                            // TODO: Check for null
                            // var proxy = GoogleSheetsProxy(
                            //     (await SecureStorage.readFromKey(
                            //         SecureStorageConstants.SPREADSHEET_IDS))!);
                            // proxy.waitForCompleteSetUp().then((_) {
                            //   proxy.addOCRBoxesToSheet(result);
                            //   showDialog(
                            //       context: context,
                            //       builder: (BuildContext context) {
                            //         return const SuccessAlertBox();
                            //       }).then((_) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        SpreadsheetSubmissionSummary(
                                          categoryAmountPairs: result,
                                        )));
                            // Navigator.of(context)
                            //     .popUntil((route) => route.isFirst);
                            // });
                            // });
                          }
                        },
                        color: Colors.white,
                        child: Text(
                          "Send to Sheets",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ))
                  ],
                );
              } else if (snapshot.hasError) {
                return const Text("Something went wrong :(");
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )
        ]);
  }

  List<Widget> _displayOCRBoxes(List<Key> keys, ParsedResult parsedResult,
      BoxConstraints constraints, int imageWidth, int imageHeight) {
    if (createdBoxes.isEmpty) {
      return _generateOCRBoxes(
          keys, parsedResult, constraints, imageWidth, imageHeight);
    } else {
      return createdBoxes;
    }
  }

  List<Widget> _generateOCRBoxes(List<Key> keys, ParsedResult parsedResult,
      BoxConstraints constraints, int imageWidth, int imageHeight) {
    List<OCRBox> boxes = [];

    if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
      return boxes;
    }

    int keyIndex = 0;

    double widthRatio = constraints.maxWidth / imageWidth;
    double heightRatio = constraints.maxHeight / imageHeight;
    double scaleFactor = widthRatio < heightRatio ? widthRatio : heightRatio;

    for (int i = 0; i < parsedResult.textOverlay.lines.length; i++) {
      for (int j = 0; j < parsedResult.textOverlay.lines[i].words.length; j++) {
        Word givenBox = parsedResult.textOverlay.lines[i].words[j];
        OCRBox box = OCRBox(
            key: keys[keyIndex],
            left: givenBox.left * scaleFactor,
            top: givenBox.top * scaleFactor,
            height: givenBox.height * scaleFactor,
            width: givenBox.width * scaleFactor,
            ocrBoxData: OCRBoxData.validationNeeded(
                lineText: givenBox.wordText, possibleCategories: categories));
        if (box.ocrBoxData.priceConfidence != TextIsPriceConfidence.notPrice) {
          boxes.add(box);
          keyIndex++;
        } else {
          keys.removeAt(keyIndex);
        }
      }
    }

    setCreatedBoxes(boxes);
    return boxes;
  }

  void setCreatedBoxes(List<OCRBox> boxes) {
    createdBoxes = boxes;
  }

  Future<List<dynamic>> initBuilder(File image) async {
    List<dynamic> createdObjects = [];

    createdObjects.add(await scanReceipt(image));
    createdObjects.add(await ImageDimensions.imageDimensionsFromAsset(
        'assets/images/bbyRec.jpg'));

    return createdObjects;
  }

  List<Key> _generateOCRBoxKeys(ParsedResult parsedResult) {
    List<Key> keys = [];

    for (int i = 0; i < parsedResult.textOverlay.lines.length; i++) {
      for (int j = 0; j < parsedResult.textOverlay.lines[i].words.length; j++) {
        keys.add(UniqueKey());
      }
    }

    return keys;
  }

  Map<String, Decimal>? getAndVerifyOCRBoxes(
      List<OCRBox> boxes, BuildContext context) {
    var selectedBoxes =
        boxes.where((element) => element.ocrBoxData.selected == true);
    if (selectedBoxes
        .any((element) => element.ocrBoxData.assignedCategory == null)) {
      showDialog(
          context: context,
          builder: (BuildContext bContext) {
            return const ErrorAlertBox(
                errorMessage:
                    "All boxes must have be assigned an expense category. Try again after labeling all boxes.");
          });
      return null;
    }
    var isTotalBoxes =
        selectedBoxes.where((element) => element.ocrBoxData.isTotal == true);

    if (isTotalBoxes.length == 1) {
      // subtract other that isn't total categories from
      return removeSubtotalsFromTotalMethod(
          selectedBoxes, isTotalBoxes, context);
    } else if (isTotalBoxes.isEmpty) {
      // sum up all the selected boxes.
      return sumSubtotalsMethod(selectedBoxes);
    } else {
      // display notification saying you need to only have one total.
      showDialog(
          context: context,
          builder: (BuildContext bContext) {
            return const ErrorAlertBox(
                errorMessage:
                    "Only one box may be labeled as being the total. All boxes labeled as a total are reset to not be.");
          });
      for (var element in isTotalBoxes) {
        element.ocrBoxData.isTotal = false;
      }
      return null;
    }
  }

  Map<String, Decimal>? removeSubtotalsFromTotalMethod(
      Iterable<OCRBox> selectedBoxes,
      Iterable<OCRBox> isTotalBoxes,
      BuildContext context) {
    Map<String, Decimal> categoryTotals = Map.fromEntries(
        categories.map((category) => MapEntry(category, Decimal.zero)));
    var ocrBoxDataList = selectedBoxes
        .map((e) => e.ocrBoxData)
        .where((element) => element.isTotal == false)
        .toList();
    try {
      String totalCategory = isTotalBoxes.first.ocrBoxData.assignedCategory!;
      categoryTotals[isTotalBoxes.first.ocrBoxData.assignedCategory!] =
          Decimal.parse(isTotalBoxes.first.ocrBoxData.lineText);

      for (var element in ocrBoxDataList) {
        if (element.assignedCategory != totalCategory) {
          Decimal curTotal = categoryTotals[element.assignedCategory!]!;
          categoryTotals[element.assignedCategory!] = curTotal +
              Decimal.parse(element.lineText.replaceAll(RegExp(r'[^0-9.]'),
                  '')); // replaces any $ or other non-numeric characters

          Decimal totalRunningTotal = categoryTotals[totalCategory]!;
          categoryTotals[totalCategory] =
              totalRunningTotal - Decimal.parse(element.lineText);

          if (categoryTotals[totalCategory]! < Decimal.zero) {
            showDialog(
                context: context,
                builder: (BuildContext bContext) {
                  return ErrorAlertBox(
                      errorMessage:
                          "Box marked as total is smaller than the sum of all other non-$totalCategory selected boxes");
                });
            throw Exception("The total can't be less than 0");
          }
        }
      }
      return categoryTotals;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Map<String, Decimal>? sumSubtotalsMethod(Iterable<OCRBox> selectedBoxes) {
    Map<String, Decimal> expenseCodeTotals =
        Map.fromEntries(categories.map((code) => MapEntry(code, Decimal.zero)));

    var ocrBoxDataList = selectedBoxes.map((e) => e.ocrBoxData).toList();
    try {
      for (var element in ocrBoxDataList) {
        Decimal curTotal = expenseCodeTotals[element.assignedCategory!]!;
        expenseCodeTotals[element.assignedCategory!] = curTotal +
            Decimal.parse(element.lineText.replaceAll(RegExp(r'[^0-9.]'),
                '')); // replaces any $ or other non-numeric characters
      }

      return expenseCodeTotals;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
