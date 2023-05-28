import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/categories_form.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/finalizing_setup.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/google_sheets_url_form.dart';
import 'package:receipt_to_spreadsheet/screen/New%20User%20Setup/Individual%20Forms/ocr_key_page_view.dart';
import 'package:receipt_to_spreadsheet/screen/starting_action_screen.dart';

import '../../Widgets/moving_circles.dart';
import 'Individual Forms/get_name_form.dart';

class GatherInformationForm extends StatefulWidget {
  const GatherInformationForm({super.key});

  @override
  State<GatherInformationForm> createState() => _GatherInformationFormState();
}

class _GatherInformationFormState extends State<GatherInformationForm> {
  int _currentChildIndex = 0;

  List<Widget> _children = [];

  @override
  void initState() {
    super.initState();
    _children = [
      GoogleSheetsURLForm(callback: _onContinue),
      OCRKeyPageView(callback: _onContinue),
      GetNameForm(callback: _onContinue),
      CategoriesForm(callback: _onContinue),
      FinalizingSetup(callback: _onContinue)
    ];
  }

  void _onContinue() {
    setState(() {
      if (_currentChildIndex + 1 >= _children.length) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const StartingActionScreen()));
      } else {
        _currentChildIndex++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(255, 107, 49, 216),
        child: MovingCirclesWidget(
          child: Center(
              child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 750),
            child: _children[_currentChildIndex],
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          )),
        ),
      ),
    );
  }
}
