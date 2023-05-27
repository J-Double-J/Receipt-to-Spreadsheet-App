import 'package:flutter/material.dart';

class TotalInstruction extends StatelessWidget {
  const TotalInstruction({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Marking the Total",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 24),
                    maxLines: null,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.receipt_long,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "When labeling purchases on your receipt, you can mark the receipt's total as such and give it a category that represents a large chunk of your items",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "If you have a couple of items that don't fit the category you assigned to your total, don't worry! You can categorize the items that don't fit the total's category as normal.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "For example, if you bought 9 food items and 1 decor item, you would mark the total as 'food' and the single decor item as 'decor'.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "Don't worry, we'll take care of properly calculating your expenditure for each category based on your sorting!",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 17),
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
