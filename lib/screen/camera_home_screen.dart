import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/constant/constant.dart';

class CameraHomeScreen extends StatefulWidget {
  final List<CameraDescription>? cameras;

  const CameraHomeScreen({Key? key, this.cameras}) : super(key: key);

  @override
  State<CameraHomeScreen> createState() => _CameraHomeScreenState();
}

class _CameraHomeScreenState extends State<CameraHomeScreen> {
  String? imagePath;
  bool _toggleCamera = false;
  CameraController? controller;

  @override
  void initState() {
    try {
      onCameraSelected(widget.cameras![0]);
    } catch (e) {
      logs('Exception --> $e');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.cameras!.isEmpty) {
      return Material(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            'No Camera Found',
            style: TextStyle(fontSize: 16),
          ),
        ),
      );
    }

    if (!controller!.value.isInitialized) {
      return Container();
    }

    return AspectRatio(
      aspectRatio: controller!.value.aspectRatio,
      child: Stack(
        children: <Widget>[
          CameraPreview(controller!),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 120.0,
              padding: const EdgeInsets.all(20.0),
              color: const Color.fromRGBO(00, 00, 00, 0.7),
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          _captureImage();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/ic_shutter_1.png',
                            width: 72.0,
                            height: 72.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(50.0)),
                        onTap: () {
                          if (!_toggleCamera) {
                            onCameraSelected(widget.cameras![1]);
                            setState(() {
                              _toggleCamera = true;
                            });
                          } else {
                            onCameraSelected(widget.cameras![0]);
                            setState(() {
                              _toggleCamera = false;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.asset(
                            'assets/images/ic_switch_camera_3.png',
                            color: Colors.grey[200],
                            width: 42.0,
                            height: 42.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) await controller!.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);

    controller!.addListener(() {
      if (mounted) setState(() {});
      if (controller!.value.hasError) {
        logs('Camera Error: ${controller!.value.errorDescription}');
      }
    });

    try {
      await controller!.initialize();
    } on CameraException catch (e) {
      logs('camera exception --> ${e.code} : ${e.description}');
    }

    if (mounted) setState(() {});
  }

  void _captureImage() {
    takePicture().then((XFile? filePath) {
      if (mounted) {
        setState(() {
          imagePath = filePath!.path;
        });
        if (filePath != null) {
          setCameraResult();
        }
      }
    });
  }

  void setCameraResult() {
    Navigator.pop(context, imagePath);
  }

  Future<XFile?> takePicture() async {
    if (!controller!.value.isInitialized) {
      logs('Error: select a camera first.');
      return null;
    }

    if (controller!.value.isTakingPicture) {
      return null;
    }

    try {
      XFile savedLocation = await controller!.takePicture();
      logs('Saved locs --> ${savedLocation.path}');
      return savedLocation;
    } on CameraException catch (e) {
      logs('camera exception --> ${e.code} : ${e.description}');
      return null;
    }
  }
}
