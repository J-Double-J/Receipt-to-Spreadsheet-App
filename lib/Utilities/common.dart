import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static void copyToClipboard(BuildContext context, String textToCopy,
      {Duration? duration}) {
    Clipboard.setData(ClipboardData(text: textToCopy));
    snackbarMessage(context, 'Copied to Clipboard.');
  }

  static void snackbarMessage(BuildContext context, String text,
      {Duration? duration}) {
    duration ??= const Duration(seconds: 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: Center(
          child: Text(text),
        ),
      ),
    );
  }
}
