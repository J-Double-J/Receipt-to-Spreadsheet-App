import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Common {
  static void closeKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}
