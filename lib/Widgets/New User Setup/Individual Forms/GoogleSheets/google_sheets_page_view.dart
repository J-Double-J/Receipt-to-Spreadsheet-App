import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/New%20User%20Setup/Individual%20Forms/GoogleSheets/google_sheets_default_worksheet_form.dart';
import 'package:receipt_to_spreadsheet/Widgets/New%20User%20Setup/Individual%20Forms/GoogleSheets/share_to_account.dart';

import '../../../../Models/spreadsheet_metadata.dart';
import 'google_sheets_url_form.dart';

class GoogleSheetsPageView extends StatefulWidget {
  final void Function() callback;
  final void Function(SpreadsheetMetadata)? getMetadataCallback;
  const GoogleSheetsPageView(
      {super.key, required this.callback, this.getMetadataCallback});

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
        duration: const Duration(milliseconds: 1200), curve: Curves.easeInOut);
  }

  void _onContinue() {
    if (widget.getMetadataCallback != null) {
      widget.getMetadataCallback!(_sheetMetadata!);
    }
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
          ShareToAccount(
            callback: _goToNextPage,
          ),
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
