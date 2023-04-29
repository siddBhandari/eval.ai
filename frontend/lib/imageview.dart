import 'package:flutter/material.dart';
import 'dart:io';

class ImageView extends StatelessWidget {
  final File imageFile;
  ImageView({required this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View The Image"),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            Expanded(
              child: Image.file(
                imageFile,
              ),
              flex: 30,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back),
                label: Text('Go Back'),
              ),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
