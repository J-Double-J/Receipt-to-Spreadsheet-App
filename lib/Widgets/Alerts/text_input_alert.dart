import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/alert_box.dart';

class TextInputAlert extends StatefulWidget {
  final String? title;
  final String? Function(String?) validator;
  final Future<bool> Function(String?) validationContinue;
  final Color? alertColor;
  const TextInputAlert(
      {super.key,
      this.title,
      required this.validator,
      required this.validationContinue,
      this.alertColor});

  @override
  State<TextInputAlert> createState() => _TextInputAlertState();
}

class _TextInputAlertState extends State<TextInputAlert> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  bool notValidating = true;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RecieptAlertBox(
      title: widget.title ?? "",
      alertColor: widget.alertColor,
      bodyContent: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _controller,
                maxLength: 4,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                obscureText: true,
                validator: widget.validator,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    counterStyle: const TextStyle(fontSize: 14),
                    errorStyle: const TextStyle(fontSize: 15),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            width: 2, color: Color.fromARGB(255, 182, 59, 204)),
                        borderRadius: BorderRadius.circular(20.0))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: notValidating
                      ? () {
                          Navigator.pop(context, false);
                        }
                      : null,
                  color: widget.alertColor ?? Colors.purple,
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width * 0.3,
                  onPressed: notValidating
                      ? () async {
                          _validateForm().then((validResult) {
                            if (validResult) {
                              Navigator.pop(context, true);
                            } else {
                              _formKey.currentState!.validate();
                            }
                          });
                        }
                      : null,
                  color: widget.alertColor ?? Colors.purple,
                  child: const Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<bool> _validateForm() async {
    setState(() {
      notValidating = false;
    });

    final result = await widget.validationContinue(_controller.text);

    setState(() {
      notValidating = true;
    });

    return result;
  }
}
