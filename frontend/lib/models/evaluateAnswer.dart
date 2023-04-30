import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'dart:async';

Future<String> evaluateAnswer(List<Map<String,String>>lst,String answer)async{
  String question="";
  String Rules="";
  
  for(int i=0;i<lst.length;i++){
    if(lst[i]['id']=="-1"){
      question=lst[i]['qustion']!;
    }
    else{
      String cur="marks[";
      cur+=lst[i]['marks']!;
      cur+=']:';
      cur+=lst[i]['rule']!;
      cur+='\n';
      Rules+=cur;
    }
  }

  Rules = Rules.substring(0,Rules.length-1);
  String url = 'https://8000-siddbhandari-evalai-bjugaze4uf3.ws-us96b.gitpod.io/';
  url += '/?eval_scheme=${Rules}&question=${question}&answer=${answer}';

  var response = await http.get(Uri.parse(url));

  var value = json.decode(response.body);
  return value;
}

Future<String> getOCR(String base64Image)async{
  print('4______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  String url = 'https://8000-siddbhandari-evalai-bjugaze4uf3.ws-us96b.gitpod.io/ocr';
  print(url);
  var response = await http.post(Uri.parse(url),body: {'img_data':base64Image},headers: {"Content-Type": "application/x-www-form-urlencoded",});
  print(response);
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  var value = json.decode(response.body);
  print(value);
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  print('_______________________________________________________________________');
  return value;
}