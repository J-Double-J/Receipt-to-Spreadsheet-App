import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../screen/general_settings_screen.dart';

class SlideOutSettings extends StatefulWidget {
  final AnimationController animationController;
  const SlideOutSettings({super.key, required this.animationController});

  @override
  State<SlideOutSettings> createState() => _SlideOutSettingsState();
}

class _SlideOutSettingsState extends State<SlideOutSettings> {
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _offsetAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          height: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom,
          width: MediaQuery.of(context).size.width * 0.4,
          color: Colors.white,
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey, width: 1.1),
                      bottom: BorderSide(color: Colors.grey, width: 0.55))),
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const GeneralSettings()));
                },
                child: const Text(
                  "General Settings",
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.55),
                      bottom: BorderSide(color: Colors.grey, width: 0.55))),
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  print("Hello");
                },
                child: const Text(
                  "Connection Settings",
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: double.infinity,
              decoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey, width: 0.55),
                      bottom: BorderSide(color: Colors.grey, width: 1.1))),
              child: MaterialButton(
                color: Colors.white,
                onPressed: () {
                  openAppSettings();
                },
                child: const Text(
                  "App Permissions",
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
