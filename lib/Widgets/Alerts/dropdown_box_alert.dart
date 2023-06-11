import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/receipt_alert_box.dart';

class DropdownBoxAlert extends StatefulWidget {
  final Function(String?, bool) onSave;
  final bool currentIsTotal;
  final List<String> categories;
  final String? currentCategory;

  const DropdownBoxAlert({
    super.key,
    required this.onSave,
    required this.currentIsTotal,
    required this.categories,
    this.currentCategory,
  });

  @override
  State<DropdownBoxAlert> createState() => _DropdownBoxAlertState();
}

class _DropdownBoxAlertState extends State<DropdownBoxAlert> {
  late String _selectedCategory;
  late bool _isTotal;

  @override
  void initState() {
    super.initState();
    _isTotal = widget.currentIsTotal;
    _selectedCategory = widget.currentCategory ?? widget.categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return ReceiptAlertBox(
      title: "Categorize Price",
      bodyContent: Flexible(
        flex: 82,
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 30,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Expanded(
                    child: Row(
                      children: [
                        const Text("Category:",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        const Spacer(
                          flex: 1,
                        ),
                        DropdownButton<String>(
                          value: _selectedCategory,
                          underline: Container(),
                          onChanged: (String? newValue) {
                            setState(() {
                              if (newValue != null) {
                                _selectedCategory = newValue;
                              }
                            });
                          },
                          items: widget.categories
                              .map((category) => DropdownMenuItem<String>(
                                  value: category, child: Text(category)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                child: Row(
                  children: [
                    Checkbox(
                        value: _isTotal,
                        onChanged: (bool? value) {
                          setState(() {
                            _isTotal = value!;
                          });
                        }),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isTotal = !_isTotal;
                        });
                      },
                      child: const Text(
                        "Is this the Total?",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              Expanded(
                flex: 30,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                            onPressed: () {
                              widget.onSave(null, _isTotal);
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel")),
                      ),
                      Flexible(
                        flex: 2,
                        child: Container(),
                      ),
                      Expanded(
                        flex: 4,
                        child: ElevatedButton(
                            onPressed: () {
                              widget.onSave(_selectedCategory, _isTotal);
                              Navigator.pop(context);
                            },
                            child: const Text("Confirm")),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
