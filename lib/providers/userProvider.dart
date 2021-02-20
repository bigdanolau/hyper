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
    "identifier":usuario,
    "password":password
  });
  Map<String,dynamic> res = json.decode(response.body);
  SharedPreferences pref = await setData();
  pref.setString('email',res["user"]["email"] );
  pref.setInt('id',res["user"]["id"] );
  pref.setString('pwd',password);
  pref.setString('medico',res["user"]["email_medico"]);
  if(response.statusCode != 200){
    return false;
  }
  return true;

}
Future <bool> addUser(String username,String email,String pass,String ispaciente,String sexo,String telefono,String doctor) async{
  SharedPreferences pref = await getData();
  final response = await http.post('$url'+"/register",body: {
    "username":username,
    "email":email,
    "password":pass,
    "is_paciente":ispaciente,
    "sexo":sexo,
    "email_medico": doctor
  });

  print(response.body);
  
  if(response.statusCode ==200) return true;
  print(response);
  return false;
}

 Future<SharedPreferences> setData() async {
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  return prefs;
}
 Future<SharedPreferences> getData() async {
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  return prefs;
}