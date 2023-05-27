import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receipt_to_spreadsheet/Widgets/Alerts/error_alert_box.dart';
import 'package:receipt_to_spreadsheet/Widgets/dashed_border_container.dart';
import 'package:receipt_to_spreadsheet/Widgets/Scaffold/receipt_scaffold.dart';
import 'package:receipt_to_spreadsheet/screen/camera_screen.dart';
import 'package:receipt_to_spreadsheet/screen/image_preview_screen.dart';

class StartingActionScreen extends StatelessWidget {
  const StartingActionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReceiptScaffold(automaticallyImplyLeading: false, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(
                10, 10, 10, MediaQuery.of(context).size.height * 0.2),
            child: Center(
                child: Text(
              "How would you like to scan your receipt?",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 30),
            )),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraApp()));
                    },
                    child: DashedBorderContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                    scale: 1.75,
                                    child: Icon(
                                      Icons.photo_camera,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                Text("Camera",
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18))
                              ]),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  child: MaterialButton(
                    padding: EdgeInsets.zero,
                    onPressed: () async {
                      Future<XFile?> pickedFile;
                      Permission.storage.request().then((permissionStatus) {
                        debugPrint(permissionStatus.toString());
                        if (permissionStatus.isGranted) {
                          ImagePicker picker = ImagePicker();
                          pickedFile =
                              picker.pickImage(source: ImageSource.gallery);
                          pickedFile.then((file) {
                            if (file != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ImagePreview(file)));
                            }
                          });
                          print("Success");
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ErrorAlertBox(
                                  errorMessage:
                                      "App needs access to your gallery to be able to upload image to scan. Would you like to change your permissions for this app?",
                                  buttons: [
                                    MaterialButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: const Text(
                                        "Cancel",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    MaterialButton(
                                      onPressed: () {
                                        openAppSettings().then((value) =>
                                            Navigator.of(context).pop());
                                      },
                                      color: Theme.of(context).primaryColor,
                                      child: const Text(
                                        "Edit Permissions",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                );
                              });
                        }
                      });
                    },
                    child: DashedBorderContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Transform.scale(
                                    scale: 1.75,
                                    child: Icon(
                                      Icons.folder,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      0.025,
                                ),
                                Text("Storage",
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 18))
                              ]),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )
    ]);
  }
}
