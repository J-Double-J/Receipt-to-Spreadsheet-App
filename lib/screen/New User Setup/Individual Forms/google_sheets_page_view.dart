import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/google_sheets_default_worksheet_form.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/google_sheets_url_form.dart';

import '../../../Models/spreadsheet_metadata.dart';

class GoogleSheetsPageView extends StatefulWidget {
  final void Function() callback;
  final void Function(SpreadsheetMetadata) getMetadataCallback;
  const GoogleSheetsPageView(
      {super.key, required this.callback, required this.getMetadataCallback});

  @override
  State<GoogleSheetsPageView> createState() => _GoogleSheetsPageViewState();
}

class _GoogleSheetsPageViewState extends State<GoogleSheetsPageView> {
  final PageController _pageController = PageController();
  late List<Widget> pages;
  int _currentPageIndex = 0;
  SpreadsheetMetadata? _sheetMetadata;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  Future<void> createSheetMetadata(String id) async {
    var metadata = await SpreadsheetMetadata.create(id);

    setState(() {
      _sheetMetadata = metadata;
    });

    return Future.value();
  }

  void _goToNextPage() {
    _pageController.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  void _onContinue() {
    widget.getMetadataCallback(_sheetMetadata!);
    widget.callback();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: PageView(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          GoogleSheetsURLForm(
            callback: _goToNextPage,
            setSheetIDCallback: createSheetMetadata,
          ),
          DefaultWorksheetForm(
            callback: _onContinue,
            sheetMetadata: _sheetMetadata,
          )
        ],
      ),
    );
  }
}
