import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage.dart';
import 'package:receipt_to_spreadsheet/Utilities/secure_storage_constants.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/alert_box.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/error_alert_box.dart';

class CategoriesForm extends StatefulWidget {
  final void Function() callback;

  const CategoriesForm({super.key, required this.callback});

  @override
  State<CategoriesForm> createState() => _CategoriesFormState();
}

class _CategoriesFormState extends State<CategoriesForm>
    with SingleTickerProviderStateMixin {
  List<String> categories = [
    "Food",
    "Gas",
    "Furniture",
    "Household Goods",
    "Date",
    "Entertainment",
    "Decor",
  ];
  late AnimationController _animationController;
  late AnimatedListState _listState;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  late final ScrollController _scrollController;

  late List<Key> itemKeys;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    itemKeys = List.generate(
        categories.length, (index) => ValueKey(categories[index]));
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                height: MediaQuery.of(context).size.height * 0.76,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(
                      color: const Color.fromARGB(255, 78, 43, 177), width: 3),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text(
                        "Price Categories",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 107, 49, 216),
                        ),
                      ),
                    ),
                    Expanded(
                      child: AnimatedList(
                        key: _listKey,
                        controller: _scrollController,
                        initialItemCount: categories.length + 1,
                        itemBuilder: (context, index, animation) {
                          if (index < categories.length) {
                            return _buildAnimatedItem(index, animation);
                          } else {
                            // This button does give an "Incorrect use of ParentDataWidget." after inserting once. Not sure how to fix.
                            // The behavior works as intended though.
                            return Material(
                              child: InkWell(
                                splashColor: Colors.red,
                                child: ListTile(
                                    onTap: () async {
                                      String? addedValue = await showDialog(
                                          context: context,
                                          builder: (builder) {
                                            return RecieptAlertBox(
                                              title: "New Category",
                                              bodyContent:
                                                  _addAlertBodyContent(),
                                            );
                                          });
                                      if (addedValue != null) {
                                        setState(() {
                                          categories.add(addedValue);
                                          itemKeys.add(ValueKey(addedValue));
                                        });
                                        _listKey.currentState!
                                            .insertItem(categories.length);
                                        await Future.delayed(
                                            const Duration(milliseconds: 400));
                                        if (_scrollController.hasClients) {
                                          _scrollController.animateTo(
                                              _scrollController
                                                  .position.maxScrollExtent,
                                              duration: const Duration(
                                                  milliseconds: 250),
                                              curve: Curves.easeInOut);
                                        }
                                      }
                                    },
                                    key: const ValueKey('addMore'),
                                    leading: const IntrinsicWidth(
                                        child: Icon(
                                      Icons.add,
                                      color: Color.fromARGB(255, 107, 49, 216),
                                    )),
                                    title: const Text(
                                      "Add more...",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 107, 49, 216),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )),
                              ),
                            );
                          }
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              ),
              // const SizedBox(
              //   height: 20,
              // ),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: MaterialButton(
                  onPressed: () {
                    if (categories.isNotEmpty) {
                      SecureStorage.writeListToKey(
                          SecureStorageConstants.CATEGORIES, categories);
                      widget.callback();
                    } else {
                      showDialog(
                          context: context,
                          builder: (builder) {
                            return const ErrorAlertBox(
                                errorMessage:
                                    "You must have at least one category before you can continue");
                          });
                    }
                  },
                  minWidth: MediaQuery.of(context).size.width * 0.7,
                  color: Colors.white,
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                        color: Color.fromARGB(255, 107, 49, 216),
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedItem(int index, Animation<double> animation) {
    return Column(
      children: [
        ListTile(
            key: itemKeys[index],
            title: Text(
              categories[index],
              style: const TextStyle(
                  color: Color.fromARGB(255, 107, 49, 216),
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            trailing: IntrinsicWidth(
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Container(
                  width: 1.0,
                  height: MediaQuery.of(context).size.height * 0.055,
                  color:
                      const Color.fromARGB(255, 107, 49, 216).withOpacity(0.4)),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Color.fromARGB(255, 107, 49, 216),
                      ),
                      onPressed: () => _removeItem(index)),
                ),
              ),
            ]))),
        const Divider(
          color: Color.fromARGB(255, 107, 49, 216),
          thickness: 1,
          height: 1,
        )
      ],
    );
  }

  void _removeItem(int index) {
    setState(() {
      String removedItem = categories.removeAt(index);
      _listKey.currentState?.removeItem(index,
          (context, animation) => _buildRemovedItem(removedItem, animation),
          duration: const Duration(milliseconds: 300));
    });
  }

  Widget _buildRemovedItem(String removedItem, Animation<double> animation) {
    final curvedAnimation =
        CurvedAnimation(parent: animation, curve: const Interval(0.0, 0.9));

    return SizeTransition(
      sizeFactor: curvedAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
            .animate(animation),
        child: ListTile(
          title: Text(removedItem),
        ),
      ),
    );
  }

  Widget _addAlertBodyContent() {
    final TextEditingController textcontroller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Form(
              key: formKey,
              child: TextFormField(
                maxLength: 15,
                controller: textcontroller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).primaryColor, width: 2))),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Must enter a value";
                  }

                  String lowercaseValue = value.toLowerCase();
                  if (categories.any(
                      (element) => element.toLowerCase() == lowercaseValue)) {
                    return "That category entry already exists";
                  }

                  return null;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context, null);
                },
                color: Theme.of(context).primaryColor,
                minWidth: 125,
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.pop(context, textcontroller.text);
                  }
                },
                minWidth: 125,
                color: Theme.of(context).primaryColor,
                child: const Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
