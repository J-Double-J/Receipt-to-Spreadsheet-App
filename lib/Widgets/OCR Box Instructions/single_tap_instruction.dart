import 'package:flutter/material.dart';

class SingleTapInstruction extends StatelessWidget {
  const SingleTapInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "With a Single Tap...",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 24,
                      color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                Icon(
                  Icons.price_check,
                  size: 70,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  "Simply tap on a price box to mark or unmark it for sending to your spreadsheet. When you tap a price for the first time, you'll need to assign it a category, such as 'food' or 'decor'.",
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Any selected box will be highlighted in green! It's as easy as that!",
                  style: TextStyle(
                      fontSize: 18, color: Theme.of(context).primaryColor),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          )
          // Text(
          //   "Single-tap: Simply tap on a price box to enable or disable it for sending to the spreadsheet. When you enable a price for the first time, you'll need to assign it a category, such as 'food' or 'decor'. It's as easy as that!",
          //   style:
          //       TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          //   textAlign: TextAlign.center,
          //   maxLines: null,
          // )

          ),
    );
  }
}
