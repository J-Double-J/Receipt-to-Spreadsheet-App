import 'package:flutter/material.dart';

class LongPressInstruction extends StatelessWidget {
  const LongPressInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Edit and Categorize Effortlessly",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.category,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Need to change the category assigned to a price? Give a long-press on any price box to open its editing options. You'll be presented with a convenient menu to update its category or designate it as the total.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Categorize one box for the whole receipt, or categorize individual prices. Managing your expenses has never been this smooth!",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
