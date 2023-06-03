import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  static void copyToClipboard(BuildContext context, String text,
      {Duration? duration}) {
    duration ??= const Duration(seconds: 1);

    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        content: const Center(
          child: Text('Copied to Clipboard.'),
        ),
      ),
    );
  }
}
