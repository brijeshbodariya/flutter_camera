import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera/constant/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _imagePath;
  Widget? image;
  final double _headerHeight = 320.0;
  final String _assetImagePath = 'assets/images/ic_no_image.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        _imagePath != null
            ? _getImageFromFile(_imagePath!)
            : _getImageFromAsset(),
        _getCameraFab(),
        _getLogo(),
      ],
    ));
  }

  Widget _getImageFromAsset() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Container(
          width: double.infinity,
          height: _headerHeight,
          color: Colors.grey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                _assetImagePath,
                //fit: BoxFit.fill,
                width: 60.0,
                height: 60.0,
                //centerSlice: Rect.fromLTRB(2.0, 2.0, 2.0, 2.0),
                //colorBlendMode: BlendMode.srcOver,
                //color: Color.fromARGB(120, 20, 10, 40),
              ),
              Container(
                margin: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'No Image Available',
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget _getImageFromFile(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: _headerHeight,
      ),
    );
  }

  Widget _getCameraFab() {
    return Positioned(
      top: _headerHeight - 30.0,
      right: 16.0,
      child: FloatingActionButton(
        onPressed: _openCamera,
        child: const Icon(Icons.photo_camera, color: Colors.white),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _getLogo() {
    return Container(
      margin: const EdgeInsets.only(top: 200.0),
      alignment: Alignment.center,
      child: Center(
        child: Image.asset(
          'assets/images/ic_flutter_devs_logo.png',
          width: 160.0,
          height: 160.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Future<void> _openCamera() async {
    final imagePath = await Navigator.of(context).pushNamed(cameraScreen);

    setState(() {
      _imagePath = imagePath as String?;
    });

    if (imagePath != null) {
      logs('Image path --> $imagePath');

      image = Image.file(
        File('$imagePath'),
        height: _headerHeight,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }
}
