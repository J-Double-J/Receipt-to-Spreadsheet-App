import 'package:flutter/material.dart';

import '../Models/ocr_box_data.dart';
import 'Alerts/dropdown_box_alert.dart';

class OCRBox extends StatefulWidget {
  final double left;
  final double top;
  final double height;
  final double width;
  final OCRBoxData ocrBoxData;

  const OCRBox(
      {super.key,
      required this.left,
      required this.top,
      required this.height,
      required this.width,
      required this.ocrBoxData});

  @override
  State<OCRBox> createState() => _OCRBoxState();
}

class _OCRBoxState extends State<OCRBox> {
  late Color containerBackgroundColor;
  late Color containerTextColor;

  @override
  void initState() {
    super.initState();
    containerBackgroundColor = _getBackgroundColor(widget.ocrBoxData);
    containerTextColor = _getTextColor(widget.ocrBoxData);
  }

  void _updateColors() {
    containerBackgroundColor = _getBackgroundColor(widget.ocrBoxData);
    containerTextColor = _getTextColor(widget.ocrBoxData);
  }

  Future<void> _showChooseCategoryAlert() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return DropdownBoxAlert(
            onSave: widget.ocrBoxData.assignCategory,
            currentIsTotal: widget.ocrBoxData.isTotal,
            categories: widget.ocrBoxData.possibleCategories,
            currentCategory: widget.ocrBoxData.assignedCategory,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: GestureDetector(
        onTap: () async {
          if (widget.ocrBoxData.assignedCategory == null &&
              widget.ocrBoxData.isSelected == false) {
            await _showChooseCategoryAlert();

            // Dialog was cancelled so state shouldn't toggled;
            if (widget.ocrBoxData.assignedCategory == null) {
              return;
            }
          }
          setState(() {
            widget.ocrBoxData.toggleSelected();
            _updateColors();
          });
        },
        onLongPress: () async {
          await _showChooseCategoryAlert();
          setState(() {
            widget.ocrBoxData.isSelected = true;
            _updateColors();
          });
        },
        child: Container(
          height: widget.height,
          width: widget.width,
          color: containerBackgroundColor,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(widget.ocrBoxData.line,
                style: TextStyle(color: containerTextColor, fontSize: 26)),
          ),
        ),
      ),
    );
  }
}

Color _getBackgroundColor(OCRBoxData boxData) {
  if (boxData.isSelected) {
    return const Color.fromARGB(255, 46, 97, 46);
  } else if (boxData.priceConfidence == TextIsPriceConfidence.isPrice) {
    return Colors.green.withOpacity(0.5);
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.isPossibleAmount) {
    return const Color.fromARGB(255, 144, 36, 163).withOpacity(0.5);
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.possibleHiddenPrice) {
    return Colors.yellow.withOpacity(0.5);
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.possibleHiddenAmount) {
    return Colors.orange.withOpacity(0.5);
  }

  return const Color.fromARGB(255, 247, 105, 95).withOpacity(0.5);
}

Color _getTextColor(OCRBoxData boxData) {
  if (boxData.isSelected) {
    return Colors.white;
  } else if (boxData.priceConfidence == TextIsPriceConfidence.isPrice) {
    return Colors.black;
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.isPossibleAmount) {
    return Colors.white;
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.possibleHiddenPrice) {
    return Colors.black;
  } else if (boxData.priceConfidence ==
      TextIsPriceConfidence.possibleHiddenAmount) {
    return Colors.black;
  }
  return Colors.white;
}
