import 'package:flutter/material.dart';

class OCRInformation extends StatefulWidget {
  const OCRInformation({super.key});

  @override
  State<OCRInformation> createState() => _OCRInformationState();
}

class _OCRInformationState extends State<OCRInformation> {
  final double expansionTileBodyTextSize = 16.5;
  final double expansionTileHeaderTextSize = 19;
  final double bodyPadding = 24;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(children: [
            ExpansionTile(
              title: Text(
                "What is OCR?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tOCR stands for 'Optical Character Recognition'. This is technology that is used to recognize and interpret characters in images or scanned documents."
                    " ocr.space is a company that scans documents on their servers and sends the results back to your device.",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Why do I need to enroll for a key on ocr.space?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tocr.space is a website that will scan your receipts for you, instead of using your device to do so. Scanning is computationally expensive to do, and is not appropriate to attempt on a phone "
                    "due to power use and length of time needed, thus it is best to send the work elsewhere. ocr.space is a free resource to use to scan and is likely to meet the needs to of a casual user.",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tDue to this app being developed by a single developer and released for free, it is infeasible for the developer to buy a premium key to cover all users. So unfortunately the effort of "
                    "getting a key is put onto you, the user. You should only need to do this set up once for the lifetime of the app!",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Is there any reason I would want a premium key?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tUnlikely. If you are a casual user that scans a couple of receipts a day, you will never hit your cap of 25,000 scans a month. Premium keys also allow faster scans, but tests on our endshow that scans should be completed in under 5-7 seconds assuming a strong internet connection. Finally, a premium key will garuntee you that your service will have 100% uptime whereas the free key gives no such garuntee. This should not be a problem though because this app allows you to scan receipts from your device storage, so you could always try again later.",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "What will you do with my key?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tThe key allows us to communicate with ocr.space and count each request to your account. Your key will not be stored anywhere off your device and will only be used to scan any receipts "
                    "you tell us to scan for you.",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Does ocr.space keep copies of my receipts or files?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                    padding: EdgeInsets.all(bodyPadding),
                    child: Text(
                      "No.",
                      style: TextStyle(fontSize: expansionTileBodyTextSize),
                    ))
              ],
            ),
            ExpansionTile(
              title: Text(
                "Is this app affiliated with ocr.space?",
                style: TextStyle(fontSize: expansionTileHeaderTextSize),
              ),
              children: [
                Container(
                  padding: EdgeInsets.all(bodyPadding),
                  child: Text(
                    "\tNo, ocr.space was a service that was chosen for it's ease of use and services provided. If you purchase a premium key, all proceeds go to them entirely.",
                    style: TextStyle(fontSize: expansionTileBodyTextSize),
                  ),
                )
              ],
            )
          ]),
        ),
      ),
    );
  }
}
