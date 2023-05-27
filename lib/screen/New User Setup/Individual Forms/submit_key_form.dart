import 'package:flutter/material.dart';

import '../../../Proxies/ocr_proxy.dart';
import '../../../Utilities/secure_storage.dart';
import '../../../Utilities/secure_storage_constants.dart';

class SubmitKeyForm extends StatefulWidget {
  final void Function() callback;
  const SubmitKeyForm({super.key, required this.callback});

  @override
  State<SubmitKeyForm> createState() => _SubmitKeyFormState();
}

class _SubmitKeyFormState extends State<SubmitKeyForm> {
  final _formKey = GlobalKey<FormState>();
  final _keyController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _keyController.dispose();
  }

  Future<bool> verifyAndStoreOCRKey() async {
    setState(() {
      isLoading = true;
    });

    bool successfulValidation = false;
    if (await OCRProxy.validateOCRKey(_keyController.text)) {
      SecureStorage.writeToKey(
          SecureStorageConstants.OCR_KEY, _keyController.text);
      successfulValidation = true;
    } else {
      _formKey.currentState!.validate();
    }

    setState(() {
      isLoading = false;
    });

    return successfulValidation;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(children: const [
                    Text(
                      "Input your OCR Key",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Can't find your key? It should be emailed to you.",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w500),
                    ),
                  ]),
                ),
                Form(
                  key: _formKey,
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: TextFormField(
                        style: TextStyle(color: Theme.of(context).primaryColor),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          errorStyle: const TextStyle(color: Colors.white),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 182, 59, 204)),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        controller: _keyController,
                        validator: (value) {
                          // The validator here should only be called when the async call returns false. This will
                          // always return an error for the form here.
                          if (value == null || value.isEmpty) {
                            return "You must enter a key.";
                          }

                          return "This key hasn't been activated yet, or is not valid. Try again.";
                        },
                      )),
                ),
                MaterialButton(
                  onPressed: () async {
                    verifyAndStoreOCRKey().then((verified) {
                      if (verified) {
                        widget.callback();
                      }
                    });
                  },
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  color: const Color.fromARGB(255, 182, 59, 204),
                  child: const Text(
                    "Continue",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          isLoading
              ? Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
