import 'package:flutter/material.dart';

class EditAnswer extends StatefulWidget {
  static const routeName = './editAnswer';
  Function? editingController;
  EditAnswer({this.editingController});
  @override
  State<EditAnswer> createState() => _EditAnswerState();
}

class _EditAnswerState extends State<EditAnswer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your answer"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Enter Your Answer',
              ),
              onChanged: (value) => widget.editingController!(value),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
