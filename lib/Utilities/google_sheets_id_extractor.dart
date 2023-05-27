class GoogleSheetsIDExtractor {
  static bool isGoogleSheetsURL(String url) {
    final RegExp pattern = RegExp(r"docs\.google\.com\/spreadsheets\/d\/");
    return pattern.hasMatch(url);
  }

  static String? extractIDFromURL(String url) {
    final match = RegExp(r'/d/([^/]+)/edit').firstMatch(url);
    return match?.group(1);
  }
}
