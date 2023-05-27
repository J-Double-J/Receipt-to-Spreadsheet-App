import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/slide_out_settings.dart';

class ReceiptScaffold extends StatefulWidget {
  final List<Widget> children;
  final String? title;
  final bool automaticallyImplyLeading;
  final bool hasHelp;
  final void Function()? helpCallback;

  const ReceiptScaffold(
      {super.key,
      required this.children,
      this.title,
      this.hasHelp = false,
      this.helpCallback,
      this.automaticallyImplyLeading = true});

  @override
  State<ReceiptScaffold> createState() => _ReceiptScaffoldState();
}

class _ReceiptScaffoldState extends State<ReceiptScaffold>
    with SingleTickerProviderStateMixin {
  final int menuOpeningAnimationLength = 250;
  bool _showAccountMenu = false;

  late AnimationController _controller;
  // late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: menuOpeningAnimationLength),
        vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void toggleShowAccountMenu() {
    _showAccountMenu = !_showAccountMenu;

    if (_showAccountMenu) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(widget.title ?? ""),
            automaticallyImplyLeading: widget.automaticallyImplyLeading,
            actions: [
              widget.hasHelp
                  ? IconButton(
                      onPressed: () {
                        if (widget.helpCallback != null) {
                          widget.helpCallback!();
                        }
                      },
                      icon: const Icon(
                        Icons.help_outline,
                      ))
                  : Container(),
              IconButton(
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  setState(() {
                    toggleShowAccountMenu();
                  });
                },
              ),
            ]),
        body: Stack(
          children: [
            ...widget.children,
            AnimatedOpacity(
              opacity: _showAccountMenu ? 1.0 : 0.0,
              duration: Duration(milliseconds: menuOpeningAnimationLength),
              child: IgnorePointer(
                ignoring: !_showAccountMenu,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      toggleShowAccountMenu();
                    });
                  },
                  child: Container(
                    color: Colors.black.withAlpha(125),
                  ),
                ),
              ),
            ),
            SlideOutSettings(animationController: _controller)
          ],
        ));
  }
}
