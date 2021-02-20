import 'dart:convert';

import 'package:hypersafe/models/loginModel.dart';
import 'package:hypersafe/models/loginModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


String url = 'http://3.21.105.7:1337/auth/local';
String token = "";
String email = "";

Future<bool> login(usuario,password) async{
  final response = await http.post('$url',body:{
    "identifier":"ivelasquezd1@unicartagena.edu.co",
    "password":"Hypersafe2021"
  });
  Map<String,dynamic> res = json.decode(response.body);
  SharedPreferences pref = await getData();
  print(pref.getString('email'));
  if(response.statusCode != 200){
    return false;
  }
  return true;

}

 Future<SharedPreferences> getData() async {
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  return prefs;
}