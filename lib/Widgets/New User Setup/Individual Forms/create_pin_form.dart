import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:receipt_to_spreadsheet/auth/hash_utility.dart';

class CreatePINForm extends StatefulWidget {
  final void Function() callback;
  const CreatePINForm({super.key, required this.callback});

  @override
  State<CreatePINForm> createState() => _CreatePINFormState();
}

class _CreatePINFormState extends State<CreatePINForm> {
  final TextEditingController _controllerOne = TextEditingController();
  final TextEditingController _controllerTwo = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _controllerOne.dispose();
    _controllerTwo.dispose();
  }

  String? validateFields(String? value) {
    if (_controllerOne.text != _controllerTwo.text) {
      return "PINs do not match";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
          child: Container(
        padding: const EdgeInsets.all(8),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          const SizedBox(),
          Column(
            children: const [
              Text(
                "Create a simple PIN",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "This will be used if you want to change or check your OCR key at a later date.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: const [
                              Text(
                                "Create PIN",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _controllerOne,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          obscureText: true,
                          cursorColor: const Color.fromARGB(255, 107, 49, 216),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 107, 49, 216)),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            counterStyle: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            errorStyle: const TextStyle(color: Colors.white),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 182, 59, 204)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: const [
                              Text("Confirm PIN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15)),
                            ],
                          ),
                        ),
                        TextFormField(
                          controller: _controllerTwo,
                          maxLength: 4,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          obscureText: true,
                          cursorColor: const Color.fromARGB(255, 107, 49, 216),
                          style: const TextStyle(
                              color: Color.fromARGB(255, 107, 49, 216)),
                          validator: validateFields,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            counterStyle: const TextStyle(
                                color: Colors.white, fontSize: 14),
                            errorStyle: const TextStyle(
                                color: Colors.white, fontSize: 15),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2,
                                  color: Color.fromARGB(255, 182, 59, 204)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
          ),
          MaterialButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                HashUtility.storePIN(_controllerTwo.text);
                widget.callback();
              }
            },
            color: Colors.white,
            minWidth: MediaQuery.of(context).size.width * 0.7,
            child: const Text(
              "Submit",
              style: TextStyle(
                  color: Color.fromARGB(255, 107, 49, 216),
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          )
        ]),
      )),
    );
  }
}
