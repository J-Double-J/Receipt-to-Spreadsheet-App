import 'package:flutter/material.dart';

class ColorGuideInstruction extends StatelessWidget {
  const ColorGuideInstruction({super.key});

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
                    "Receipt Text Color-Coding",
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
                    Icons.palette,
                    size: 70,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Once your receipt has been scanned, we employ a robust categorization system to classify the text within the receipt. This categorization serves to determine our confidence level in identifying prices that you can submit. Below are the four categories we employ, each represented by a distinct color scheme:",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.center,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "\t\t1) Light green: This color indicates that we are absolutely certain the text corresponds to a price.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.left,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "\t\t2) Purple: This color signifies a high level of confidence that it represents a price.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.left,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "\t\t3) Yellow: If the text is highlighted in yellow, it suggests the presence of a potential price with a '\$' symbol. However, we may require your assistance in confirming and extracting the accurate price.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.left,
                    maxLines: null,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    "\t\t4) Orange: In the case of orange-highlighted text, it indicates that we have identified a numerical value that could potentially be a price. Here again, we may need your help to validate and extract the correct price.",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 18),
                    textAlign: TextAlign.left,
                    maxLines: null,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
