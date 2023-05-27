import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/slide_out_settings.dart';

class ReceiptScaffoldToggleableAppbar extends StatefulWidget {
  String? title;
  List<Widget> children;
  bool showAppBar;
  bool hasHelp;
  bool automaticallyImplyLeading;
  final void Function()? helpCallback;
  bool resizeToAvoidBottomInset;

  ReceiptScaffoldToggleableAppbar(
      {super.key,
      this.title,
      required this.children,
      required this.showAppBar,
      this.hasHelp = false,
      this.helpCallback,
      this.automaticallyImplyLeading = false,
      this.resizeToAvoidBottomInset = true});

  void toggleShowAppbar() {}

  @override
  State<ReceiptScaffoldToggleableAppbar> createState() =>
      _ReceiptScaffoldToggleableAppbarState();
}

class _ReceiptScaffoldToggleableAppbarState
    extends State<ReceiptScaffoldToggleableAppbar>
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
        resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
        appBar: widget.showAppBar
            ? AppBar(
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
                  ])
            : null,
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
