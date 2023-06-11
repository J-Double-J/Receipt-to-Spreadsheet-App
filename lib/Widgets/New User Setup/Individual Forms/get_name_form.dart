import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';

import '../../../Utilities/common.dart';

class GetNameForm extends StatefulWidget {
  final void Function() callback;

  const GetNameForm({super.key, required this.callback});

  @override
  State<GetNameForm> createState() => _GetNameFormState();
}

class _GetNameFormState extends State<GetNameForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "What is your name?",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w500),
              ),
              const Text(
                  "This is the name that will appear in the spreadsheet as being responsible for paying.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
              Form(
                  key: _formKey,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: _nameController,
                      style: const TextStyle(
                          color: Color.fromARGB(255, 107, 49, 216),
                          fontSize: 18),
                      cursorColor: const Color.fromARGB(255, 107, 49, 216),
                      decoration: InputDecoration(
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          errorStyle: const TextStyle(color: Colors.white)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a name. This will only be stored on your device.";
                        }

                        return null;
                      },
                    ),
                  )),
              MaterialButton(
                  onPressed: () {
                    Common.closeKeyboard(context);
                    if (_formKey.currentState!.validate()) {
                      SecureStorage.writeToKey(
                          SecureStorageConstants.NAME, _nameController.text);
                      widget.callback();
                    }
                  },
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                  child: const Text("Continue",
                      style: TextStyle(
                          color: Color.fromARGB(255, 107, 49, 216),
                          fontWeight: FontWeight.w500,
                          fontSize: 20)))
            ],
          ),
        ),
      ),
    );
  }
}
