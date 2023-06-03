import 'package:flutter/material.dart';

import '../../../../Utilities/common.dart';

class ShareToAccount extends StatelessWidget {
  final void Function() callback;
  const ShareToAccount({super.key, required this.callback});

  final emailElip =
      "receipt-to-spreadsheet@receipttospre..."; // Elipsis did not cut off at good place, so this is needed
  final actualEmail =
      "receipt-to-spreadsheet@receipttospreadsheet.iam.gserviceaccount.com";

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Container(
        padding: const EdgeInsets.all(8),
        height: MediaQuery.of(context).size.height * 0.60,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Column(
            children: const [
              Text(
                "Share your spreadsheet to this Email:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Make sure to give edit access!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(children: [
              Expanded(
                child: Text(
                  emailElip,
                  maxLines: 1,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 107, 49, 216), fontSize: 16),
                ),
              ),
              IconButton(
                  onPressed: () {
                    Common.copyToClipboard(context, emailElip);
                  },
                  icon: const Icon(Icons.content_copy))
            ]),
          ),
          MaterialButton(
            onPressed: callback,
            minWidth: MediaQuery.of(context).size.width * 0.7,
            color: Colors.white,
            child: const Text(
              "Continue",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 107, 49, 216)),
            ),
          )
        ]),
      )),
    );
  }
}
