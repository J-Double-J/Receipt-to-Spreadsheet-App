import 'package:flutter/material.dart';

class RecieptAlertBox extends StatelessWidget {
  const RecieptAlertBox(
      {super.key,
      this.title,
      this.bodyContent,
      this.alertColor,
      this.centerTitle = false});

  final String? title;
  final Widget? bodyContent;
  final Color? alertColor;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.white.withAlpha(0),
        child: IntrinsicHeight(
          child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.35),
              // height: MediaQuery.of(context).size.height * 0.35,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      flex: 18,
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 80),
                        decoration: BoxDecoration(
                            color: alertColor ?? Theme.of(context).primaryColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        // height: MediaQuery.of(context).size.height * 0.3,
                        // width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.fromLTRB(10, 2, 0, 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                title ?? "",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white),
                                textAlign: centerTitle
                                    ? TextAlign.center
                                    : TextAlign.left,
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 4),
                              child: Material(
                                color: Colors.transparent,
                                clipBehavior: Clip.antiAlias,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )),
                              ),
                            )
                          ],
                        ),
                      )),
                  Flexible(
                      flex: 82,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20))),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: bodyContent ?? Container(),
                        ),
                      ))
                ],
              )),
        ));
  }
}
