class OCRConfidencePredictor {
  static bool textIsPrice(lineText) {
    RegExp pattern = RegExp(r'^\$([0-9]{1,5}|[0-9]+\.[0-9]{2})$');
    return pattern.hasMatch(lineText);
  }

  static bool textIsPossibleAmount(lineText) {
    RegExp pattern = RegExp(r'^([0-9]{1,5}|[0-9]+\.[0-9]{2})$');
    return pattern.hasMatch(lineText);
  }

  static bool textMayContainPrice(lineText) {
    RegExp pattern = RegExp(r'^.*?\$([0-9]{1,5}|[0-9]+\.[0-9]{2}).*?$');

    return pattern.hasMatch(lineText);
  }

  static bool textMayContainAmount(lineText) {
    RegExp pattern = RegExp(r'^.*?([0-9]{1,5}|[0-9]+\.[0-9]{2}).*?$');

    return pattern.hasMatch(lineText);
  }
}
