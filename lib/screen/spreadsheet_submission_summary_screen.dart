import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Painters/summary_card_painter.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold.dart';
import 'package:receipt_to_spreadsheet/Widgets/moving_circles.dart';

import '../Painters/reversed_summary_card_painter.dart';
import '../Proxies/google_sheets_proxy.dart';
import '../Utilities/secure_storage.dart';
import '../Utilities/secure_storage_constants.dart';
import '../Widgets/Alerts/success_alert_box.dart';

class SpreadsheetSubmissionSummary extends StatefulWidget {
  late List<MapEntry<String, Decimal>> categoryAmounts;

  SpreadsheetSubmissionSummary(
      {super.key, required Map<String, Decimal> categoryAmountPairs}) {
    categoryAmounts = categoryAmountPairs.entries
        .where((entry) => entry.value != Decimal.zero)
        .map((entry) => MapEntry(entry.key, entry.value.round(scale: 2)))
        .toList();
    categoryAmounts.sort((a, b) => b.value.compareTo(a.value));
  }

  @override
  State<SpreadsheetSubmissionSummary> createState() =>
      _SpreadsheetSubmissionSummaryState();
}

class _SpreadsheetSubmissionSummaryState
    extends State<SpreadsheetSubmissionSummary> {
  @override
  Widget build(BuildContext context) {
    return ReceiptScaffold(
        scaffoldColor: const Color.fromARGB(255, 85, 30, 189),
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            // color: Theme.of(context).primaryColor,
            // decoration: const BoxDecoration(
            //     gradient: LinearGradient(colors: [
            //   Colors.purple,
            //   Color.fromARGB(255, 233, 30, 206),
            // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            // ),
            // color: const Color.fromARGB(255, 241, 176, 198),
            // color: const Color.fromARGB(255, 107, 49, 216),
            color: const Color.fromARGB(255, 29, 50, 189),
            // color: Colors.white,
            // height: double.infinity,
            // width: double.infinity,
            child: MovingCirclesWidget(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.categoryAmounts.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  height: 72,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 85, 30, 189),
                                          width: 2)),
                                  // shape: RoundedRectangleBorder(
                                  //     borderRadius: BorderRadius.circular(10),
                                  //     side: const BorderSide(
                                  //         color: Color.fromARGB(255, 233, 30, 206),
                                  //         width: 2)),
                                  // shadowColor:
                                  //     const Color.fromARGB(255, 233, 30, 206),
                                  // elevation: 10,
                                  child: CustomPaint(
                                    painter: index % 2 == 0
                                        ? SummaryCardPainter(borderRadius: 18)
                                        : SummaryCardPainterReversed(
                                            borderRadius: 18),
                                    child: ListTile(
                                      title: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 14),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FractionallySizedBox(
                                            widthFactor: 0.6,
                                            child: FittedBox(
                                              alignment: Alignment.centerLeft,
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                widget
                                                    .categoryAmounts[index].key,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                    color: index % 2 == 0
                                                        ? const Color.fromARGB(
                                                            255, 85, 30, 189)
                                                        : Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      trailing: Text(
                                        "\$${widget.categoryAmounts[index].value.toStringAsFixed(2)}",
                                        style: TextStyle(
                                            color: index % 2 == 0
                                                ? Colors.white
                                                : const Color.fromARGB(
                                                    255, 85, 30, 189),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
                  MaterialButton(
                      minWidth: MediaQuery.of(context).size.width * 0.8,
                      onPressed: () async {
                        print("Pressed");
                        var proxy = GoogleSheetsProxy(
                            (await SecureStorage.readFromKey(
                                SecureStorageConstants.SPREADSHEET_IDS))!);
                        proxy.waitForCompleteSetUp().then((_) {
                          proxy.addOCRBoxesToSheet(widget.categoryAmounts);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const SuccessAlertBox();
                              }).then((_) {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          });
                        });
                      },
                      color: Colors.white,
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                            color: Color.fromARGB(255, 85, 30, 189),
                            fontWeight: FontWeight.w600,
                            fontSize: 18),
                      ))
                ],
              ),
            ),
          )
        ]);
  }
}
