import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

List<CameraDescription> cameras = <CameraDescription>[];
const String homeScreen = "/HOME_SCREEN";
const String cameraScreen = "/CAMERA_SCREEN";

void logs(String message) {
  if (kDebugMode) {
    print(message);
  }
}
