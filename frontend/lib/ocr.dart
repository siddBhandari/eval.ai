import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_app/imageview.dart';
import 'package:image_picker/image_picker.dart';

class OCRpage extends StatefulWidget {
  static const routeName = '/OcrScreen';
  final List<Map<String, String>> rules;
  OCRpage({required this.rules});

  @override
  State<OCRpage> createState() => _OCRpageState();
}

class _OCRpageState extends State<OCRpage> {
  File? imageFile;

  void _getImageFromCamera() async {
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Evaluate Aswers'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey,
                    ),
                    height: 1000,
                    width: 500,
                    child: imageFile == null
                        ? Center(
                            child: Text(
                              'Take a picture',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                          )
                        : Image.file(
                            imageFile!,
                            fit: BoxFit.cover,
                          ),
                  ),
                  onTap: () {
                    if (imageFile == null) {
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageView(imageFile: imageFile!),
                      ),
                    );
                  },
                ),
                flex: 15,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _getImageFromCamera,
                  icon: Icon(Icons.camera),
                  label: Text("Take Picture"),
                ),
                flex: 2,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  margin: EdgeInsets.all(10),
                  height: 1000,
                  width: 500,
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Center(
                      child: Text(
                        'OCR Text',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                flex: 10,
              ),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _getImageFromCamera,
                  icon: Icon(Icons.abc),
                  label: Text("Evaluate The Script"),
                ),
                flex: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
