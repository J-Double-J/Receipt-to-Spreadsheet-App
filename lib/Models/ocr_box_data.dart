import 'package:receipt_to_spreadsheet/Models/ocr_confidence_predictor.dart';

class OCRBoxData {
  final String lineText;
  List<String> possibleCategories;
  bool selected = false;
  bool isTotal = false;
  TextIsPriceConfidence priceConfidence = TextIsPriceConfidence.notPrice;
  String? assignedCategory;

  OCRBoxData(
      {required this.lineText,
      required this.priceConfidence,
      required this.possibleCategories});

  OCRBoxData.validationNeeded(
      {required this.lineText, required this.possibleCategories}) {
    _evaluatePriceConfidence();
  }

  String get line => lineText;
  bool get isSelected => selected;

  set isSelected(bool selected) {
    this.selected = selected;
  }

  void toggleSelected() {
    selected = !selected;
  }

  void assignCategory(String? category, bool isTotal) {
    assignedCategory = category;
    this.isTotal = isTotal;
    print(assignedCategory);
    print(isTotal);
  }

  void _evaluatePriceConfidence() {
    if (OCRConfidencePredictor.textIsPrice(lineText)) {
      priceConfidence = TextIsPriceConfidence.isPrice;
    } else if (OCRConfidencePredictor.textIsPossibleAmount(lineText)) {
      priceConfidence = TextIsPriceConfidence.isPossibleAmount;
    } else if (OCRConfidencePredictor.textMayContainPrice(lineText)) {
      priceConfidence = TextIsPriceConfidence.possibleHiddenPrice;
    } else if (OCRConfidencePredictor.textMayContainAmount(lineText)) {
      priceConfidence = TextIsPriceConfidence.possibleHiddenAmount;
    }

    // Default is already notPrice
  }
}

enum TextIsPriceConfidence {
  // Contains $ and properly formatted currency decimal
  isPrice,

  // No $ found, but is a properly formatted currency decimal
  isPossibleAmount,

  // $ and properly formatted currency decimal, but there is surrounding text
  possibleHiddenPrice,

  // No $ found, but is a properly formatted currency decimal, and there is surrounding text
  possibleHiddenAmount,

  // No $ found, and no properly formatted currency decimal
  notPrice
}
