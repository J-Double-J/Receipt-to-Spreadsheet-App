import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/receipt_alert_box.dart';

class SlideInformationAlert extends StatefulWidget {
  List<Widget> content;
  SlideInformationAlert({super.key, required this.content});

  @override
  State<SlideInformationAlert> createState() => _SlideInformationAlertState();
}

class _SlideInformationAlertState extends State<SlideInformationAlert> {
  late final int slideCount;
  int currentSlide = 0;

  @override
  void initState() {
    super.initState();
    slideCount = widget.content.length;
  }

  void _onNextSlide() {
    setState(() {
      if (currentSlide + 1 >= slideCount) {
        currentSlide = 0;
      } else {
        currentSlide++;
      }
    });
  }

  void _onPreviousSlide() {
    setState(() {
      if (currentSlide - 1 < 0) {
        currentSlide = slideCount - 1;
      } else {
        currentSlide--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptAlertBox(
      title: "How to Send to Spreadsheet",
      centerTitle: true,
      bodyContent: Column(children: [
        Expanded(
          flex: 80,
          child: Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.08,
                child: IconButton(
                  onPressed: () {
                    _onPreviousSlide();
                  },
                  icon: Icon(
                    Icons.chevron_left,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              widget.content[currentSlide],
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.08,
                child: IconButton(
                  onPressed: () {
                    _onNextSlide();
                  },
                  icon: Icon(Icons.chevron_right,
                      color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 10,
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                color: Theme.of(context).primaryColor,
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ]),
          ),
        )
      ]),
    );
  }
}
