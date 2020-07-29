import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'httpRequest.dart';
import 'dart:convert';

class Uploader extends StatefulWidget {
  final File file;
  Uploader({Key key, this.file}) : super(key: key);
  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  String QueryText = ' ';

  FlutterTts flutterTts = FlutterTts();

  void speak(String text) async {
    await flutterTts.speak(text);
  }

  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://fir-practice-a632b.appspot.com');

  StorageUploadTask _uploadTask;

  void _startUpload() async {
    String filePath = 'images/main.jpg';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  void _getPrediction() async {
    String url = 'https://3b0a9dde11f1.ngrok.io/api?Query=start';
    String Data = await GetData(url);
    Data = await GetData(url);
    var DecodedData = jsonDecode(Data);

    setState(() {
      QueryText = DecodedData['Query'].toString();
    });
    speak(QueryText);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
        stream: _uploadTask.events,
        builder: (context, snapshot) {
          var event = snapshot?.data?.snapshot;

          double progressPercent =
              event != null ? event.bytesTransferred / event.totalByteCount : 0;

          return Container(
            margin: EdgeInsets.only(left: 40, right: 40),
            child: Text(
              QueryText,
              style: TextStyle(fontSize: 22),
            ),
          );
        },
      );
    } else {
      return Padding(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.03),
          child: RaisedButton.icon(
            label: Text("Generate Caption"),
            icon: Icon(Icons.arrow_forward_ios),
            onPressed: () {
              _startUpload();
              _getPrediction();
            },
          ));
    }
  }
}
