import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimeScreen(),
    );
  }
}

class TimeScreen extends StatefulWidget {
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  static const platform = MethodChannel('com.example.time/channel');
  String currentTime = "Unknown";
  File? _image;


  Future<void> _getTime() async {
      final String result = await platform.invokeMethod('getCurrentTime');
      setState(() {
        currentTime = result;
      });
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Native Time & Camera'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              'Current Time:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              currentTime,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getTime,
              child: Text('Get Current Time'),
            ),
            SizedBox(height: 30),

            _image == null
                ? Text('No image selected.')
                : Image.file(_image!),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
