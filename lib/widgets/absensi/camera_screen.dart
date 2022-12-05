import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// CameraApp is the Main Application.
class CameraScreen extends StatefulWidget {
  /// Default Constructor
  const CameraScreen({Key? key, required this.cameras}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  bool isCameraReady = false;

  void initCamera() async {
    controller = CameraController(
      widget.cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front),
      ResolutionPreset.high,
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              top: 0,
              child: CameraPreview(controller),
            ),
            Positioned(
              top: MediaQuery.of(context).viewPadding.top + 16,
              left: 16,
              child: CustomBackButton(
                onTap: () => Navigator.of(context).pop(),
              ),
            ),
            Positioned(
              bottom: 32,
              left: 10,
              right: 10,
              child: Column(
                children: [
                  const Text(
                    'Pastikan wajah anda terfoto dengan jelas',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SimpleCircleButton(onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            content: Row(
                              children: const [
                                Spacer(),
                                SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        );
                        controller.takePicture().then((value) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(value);
                        });
                      }),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            blurRadius: 15,
            spreadRadius: 0.5,
            color: Colors.black26,
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: const SizedBox(
            width: 40,
            height: 40,
            child: Icon(
              Icons.arrow_back_ios_outlined,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class SimpleCircleButton extends StatelessWidget {
  const SimpleCircleButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        minimumSize: const Size(60, 60),
        primary: Colors.white,
        shadowColor: Colors.grey,
        elevation: 20,
      ),
      onPressed: onTap,
      child: Container(),
    );
  }
}
