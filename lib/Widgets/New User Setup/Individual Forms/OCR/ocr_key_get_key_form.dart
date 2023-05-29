import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/moving_arrow_widget.dart';
import 'package:receipt_to_spreadsheet/Widgets/New%20User%20Setup/ocr_information.dart';
import 'package:url_launcher/url_launcher.dart';

class OCRKeyFormGetKey extends StatefulWidget {
  const OCRKeyFormGetKey({super.key});

  @override
  State<OCRKeyFormGetKey> createState() => _OCRKeyFormGetKeyState();
}

class _OCRKeyFormGetKeyState extends State<OCRKeyFormGetKey> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height * 0.8,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            "Next we need you to register for an OCR Key.\n\nYour key will allow us to scan your receipts.",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w400),
                            textAlign: TextAlign.center,
                          ),
                          MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OCRInformation()));
                            },
                            color: Colors.white,
                            minWidth: MediaQuery.of(context).size.width * 0.7,
                            child: const Text(
                              "Tell me More",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (await canLaunchUrl(
                                  Uri.parse("https://ocr.space/OCRAPI"))) {
                                await launchUrl(
                                    Uri.parse("https://ocr.space/OCRAPI"));
                              } else {
                                // TODO: Handle
                                print("Can't handle");
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width * 0.7,
                            color: Colors.white,
                            child: const Text(
                              "Let me see all Plans",
                              style: TextStyle(
                                  color: Colors.purple,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20),
                            ),
                          ),
                          MaterialButton(
                            onPressed: () async {
                              if (await canLaunchUrl(Uri.parse(
                                  "https://ocr.space/ocrapi/freekey"))) {
                                await launchUrl(Uri.parse(
                                    "https://ocr.space/ocrapi/freekey"));
                              } else {
                                // TODO: Handle
                                print("Can't handle");
                              }
                            },
                            minWidth: MediaQuery.of(context).size.width * 0.7,
                            color: const Color.fromARGB(255, 182, 59, 204),
                            child: const Text("Register for Free Key",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 20)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                )),
          ),
          Positioned(
            bottom: 15,
            right: 0,
            left: 0,
            child: MovingArrowWidget(
                color: Colors.white,
                verticalHeight: 25.0,
                floatingText: "Swipe Down when you have a Key",
                textStyle: const TextStyle(color: Colors.white, fontSize: 16)),
          )
        ],
      ),
    );
  }
}
