import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_app/displayEvaluation.dart';
import 'package:form_app/imageview.dart';
import 'package:image_picker/image_picker.dart';
import './models/evaluateAnswer.dart';

class OCRpage extends StatefulWidget {
  static const routeName = '/OcrScreen';
  final List<Map<String, String>> rules;
  OCRpage({required this.rules});

  @override
  State<OCRpage> createState() => _OCRpageState();
}

class _OCRpageState extends State<OCRpage> {
  File? imageFile;
  String answer = "";
  bool _isLoading = false;

  _updateAnswer(String value) {
    answer = value;
    print(answer);
  }

  void _pickFromGalery()async{
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickFile!.path);
    });
  }

  void _pickFromCamera()async{
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickFile!.path);
    });
  }

  void _tryToGetImage(){
    showAlertDialog(BuildContext context) {
      Widget cancelButton = ElevatedButton(
        child: Text("Gallery"),
        onPressed: _pickFromGalery ,
      );
      Widget continueButton = ElevatedButton(
        child: Text("Camera"),
        onPressed:  _pickFromCamera,
      );
      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("AlertDialog"),
        content: Text("From where would you like to select the image?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );
      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }
  }

  void _getImageFromCamera() async {
    XFile? pickFile = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = File(pickFile!.path);
    });

    print('1______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');

    await _tryOCR();
  }

  _tryEvaluate() async {
    setState(() {
      _isLoading = true;
    });
    if (answer == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Answer/OCR text cannot be empty"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      String ans = await evaluateAnswer(widget.rules, answer);
      setState(() {
        _isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResponseScreen(Output: ans),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Some Error Occured"),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  _tryOCR() async {
    setState(() {
      _isLoading=true;
    });
    try{
      print('2______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
      final bytes = File(imageFile!.path).readAsBytesSync();
      String img64 = base64Encode(bytes);
      print(img64);
      String ans = await getOCR(img64);
      setState(() {
        answer=ans;
        _isLoading=false;
      });
    }
    catch(e){
      setState(() {
        _isLoading=false;
      });
    }
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
                      child: imageFile == null
                          ? TextFormField(
                              decoration: InputDecoration(
                                  hintText: "Enter Your Answer"),
                              onChanged: (value) => answer = value,
                            )
                          : Text(answer),
                    ),
                  ),
                ),
                flex: 10,
              ),
              Expanded(
                child:_isLoading?Center(child: CircularProgressIndicator(),): ElevatedButton.icon(
                  onPressed: _tryEvaluate,
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
