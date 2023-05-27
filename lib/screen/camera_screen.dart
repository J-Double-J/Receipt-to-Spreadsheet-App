import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:receipt_to_spreadsheet/screen/image_preview_screen.dart';

late List<CameraDescription> cameras;

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Access was denied");
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: CameraPreview(_controller)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () async {
                  if (!_controller.value.isInitialized) {
                    return;
                  }
                  if (_controller.value.isTakingPicture) {
                    return;
                  }

                  try {
                    await _controller.setFlashMode(FlashMode.auto);
                    XFile file = await _controller.takePicture();
                    if (context.mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImagePreview(file)));
                    }
                  } on CameraException catch (e) {
                    debugPrint("Error occured while taking picture: : $e");
                    return;
                  }
                },
                child: (Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4)),
                )),
              ),
            )
            // Center(
            //   child: Container(
            //     margin: const EdgeInsets.all(20),
            //     child: MaterialButton(
            // onPressed: () async {
            //   if (!_controller.value.isInitialized) {
            //     return;
            //   }
            //   if (_controller.value.isTakingPicture) {
            //     return;
            //   }

            //   try {
            //     await _controller.setFlashMode(FlashMode.auto);
            //     XFile file = await _controller.takePicture();
            //     if (context.mounted) {
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => ImagePreview(file)));
            //     }
            //   } on CameraException catch (e) {
            //     debugPrint("Error occured while taking picture: : $e");
            //     return;
            //   }
            // },
            //         color: Colors.white,
            //         child: const Text("Take a picture")),
            //   ),
            // )
          ],
        )
      ]),
    );
  }
}
