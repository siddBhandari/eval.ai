import 'package:flutter/material.dart';

class ResponseScreen extends StatefulWidget {
  static const routeName = './responseScreen';
  final String Output;
  ResponseScreen({required this.Output});
  @override
  State<ResponseScreen> createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Evaluation"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey,
                ),
                child: Text(widget.Output),
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
