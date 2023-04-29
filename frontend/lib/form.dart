import 'package:flutter/material.dart';
import 'package:form_app/ocr.dart';

class MainForm extends StatefulWidget {
  const MainForm({super.key});

  @override
  State<MainForm> createState() => _MainFormState();
}

class _MainFormState extends State<MainForm> {
  int _count = 0;
  String mainQuestion = "";
  List<Map<String, String>> _rules = [];
  @override
  void initState() {
    super.initState();
    _count = 0;
    _rules = [];
  }

  _onSubmit() {
    if (mainQuestion == '' || _rules.length == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Questions and Rules are mandatory'),
        ),
      );
      return;
    }
    Map<String, String> mp = {'id': "-1", "qustion": mainQuestion};
    _rules.add(mp);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OCRpage(
          rules: _rules,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Evaluate answers'),
        ),
        body: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(hintText: 'Enter Your Question'),
                onChanged: (value) => mainQuestion = value,
              ),
              Padding(
                padding: EdgeInsets.only(top: 25),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    icon: Icon(Icons.add),
                  ),
                  Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _count = 0;
                      });
                    },
                    icon: Icon(Icons.refresh),
                  ),
                ],
              ),
              Container(
                height: 490,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return _row(index);
                  },
                  itemCount: _count,
                ),
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _row(int key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Rule ${key + 1}'),
            keyboardType: TextInputType.text,
            onChanged: (val) {
              _onUpdate(key, 'rule', val);
            },
          ),
          flex: 7,
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(hintText: 'Marks'),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              _onUpdate(key, 'marks', val);
            },
          ),
          flex: 3,
        ),
      ],
    );
  }

  _onUpdate(int key, String label, String val) {
    int foundKey = -1;
    Map<String, String> mp = {};
    for (var map in _rules) {
      if (map.containsKey('id')) {
        if (map['id'] == key.toString()) {
          foundKey = key;
          mp = map;
          break;
        }
      }
    }

    if (foundKey != -1) {
      _rules.removeWhere((map) {
        return map['id'] == foundKey.toString();
      });
    }
    String marks = '';
    String rule = "";
    if (mp.containsKey('marks')) {
      marks = mp['marks']!;
    }
    if (mp.containsKey('rule')) {
      rule = mp['rule']!;
    }

    if (label == 'marks') {
      marks = val;
    }
    if (label == 'rule') {
      rule = val;
    }
    Map<String, String> cur = {
      'id': key.toString(),
      'marks': marks,
      'rule': rule
    };
    _rules.add(cur);
  }
}
