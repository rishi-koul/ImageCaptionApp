import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'Uploader.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  void _clear() {
    setState(() {
      _imageFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    String QueryText = ' ';
    return Scaffold(
      body: (_imageFile != null)
          ? SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: <Widget>[
                  Image.file(
                    _imageFile,
                    height: MediaQuery.of(context).size.width * 1.2,
                  ),
                  SizedBox(height: 20),
                  Uploader(file: _imageFile),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      FloatingActionButton.extended(
                        label: Text("Take Picture"),
                        icon: Icon(Icons.photo_camera),
                        onPressed: () {
                          _pickImage(ImageSource.camera);
                          _clear();
                        },
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.16),
                      FloatingActionButton.extended(
                          label: Text("Gallery"),
                          icon: Icon(Icons.photo_library),
                          onPressed: () {
                            _pickImage(ImageSource.gallery);
                            _clear();
                          })
                    ],
                  ),
                ],
              ),
            ))
          : Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.2,
                  right: MediaQuery.of(context).size.width * 0.1),
              child: Row(
                children: <Widget>[
                  FloatingActionButton.extended(
                    label: Text("Camera"),
                    icon: Icon(Icons.photo_camera),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                  SizedBox(width: 30),
                  FloatingActionButton.extended(
                    label: Text("Gallery"),
                    icon: Icon(Icons.photo_library),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  )
                ],
              ),
            ),
    );
  }
}
