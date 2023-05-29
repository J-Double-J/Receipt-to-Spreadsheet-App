import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/New%20User%20Setup/Individual%20Forms/OCR/submit_key_form.dart';

import 'ocr_key_get_key_form.dart';

class OCRKeyPageView extends StatefulWidget {
  final void Function() callback;
  const OCRKeyPageView({super.key, required this.callback});

  @override
  State<OCRKeyPageView> createState() => _OCRKeyPageViewState();
}

class _OCRKeyPageViewState extends State<OCRKeyPageView> {
  final PageController _pageController = PageController();
  late List<Widget> pages;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      const OCRKeyFormGetKey(),
      SubmitKeyForm(callback: widget.callback)
    ];
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  _handleSwipeUp() {
    if (_currentPageIndex < pages.length - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  _handleSwipeDown() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            _handleSwipeUp();
          } else if (details.primaryVelocity! > 0) {
            _handleSwipeDown();
          }
        },
        child: PageView(
          scrollDirection: Axis.vertical,
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          children: [...pages],
        ),
      ),
    );
  }
}
