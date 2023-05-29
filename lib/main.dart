import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipt_to_spreadsheet/Models/shared_preferences_proxy.dart';
import 'package:receipt_to_spreadsheet/screen/camera_screen.dart';

import 'Widgets/New User Setup/gather_information_form_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(ChangeNotifierProvider<SharedPreferencesProxy>(
      create: (_) => SharedPreferencesProxy(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: kDebugMode,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          primaryTextTheme: const TextTheme(
            bodyMedium: TextStyle(color: Colors.white),
          )),
      home: const GatherInformationForm(),
      // home: TestContainer(),
      // home: const StartingActionScreen()
      // TODO: normally StartingActionScreen()
    );
  }
}
