import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold.dart';

import 'ocr_response_screen.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview(this.file, {super.key});
  final XFile file;
  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview>
    with SingleTickerProviderStateMixin {
  final int menuOpeningAnimationLength = 250;
  bool _showAccountMenu = false;

  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: menuOpeningAnimationLength),
        vsync: this);
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toggleShowAccountMenu() {
    _showAccountMenu = !_showAccountMenu;

    if (_showAccountMenu) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptScaffold(title: "Image Preview", children: [
      Column(
        children: [
          Expanded(
              child: Container(
                  margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: Image.asset('assets/images/bbyRec.jpg'))),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                    margin: const EdgeInsets.all(20),
                    child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OcrResponseScreen(File(
                                      /*widget.file.path*/ 'assets/images/bbyRec.jpg'))));
                        },
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Scan",
                          style: Theme.of(context).primaryTextTheme.bodyMedium,
                        ))),
              )
            ],
          ),
        ],
      )
    ]);
  }
}
