import 'dart:convert';

import 'package:hypersafe/models/medicionesModel.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
String url = 'http://3.21.105.7:1337/mediciones';

Future <List<MedicionesModel>> getMediciones() async{
  SharedPreferences pref = await getData();
  final id = pref.getInt('id');
  final response = await http.get('$url'+'/?users_permissions_user_eq='+id.toString(),headers:{
    "identifier":pref.getString('email'),
    "password":pref.getString('pwd')
  });
  final List<dynamic> decodedData = json.decode(response.body);
  
  final List<MedicionesModel> mediciones = (decodedData)
            .map<MedicionesModel>((json) => MedicionesModel.fromJson(json))
            .toList();

  return mediciones;
}
Future <bool> addMediciones(String sis,String dia,String pul,String ari) async{
  SharedPreferences pref = await getData();
  String id = pref.getInt('id').toString();
  final response = await http.post('$url',headers:{
    "identifier":pref.getString('email'),
    "password":pref.getString('pwd')
  },body: {
    "sis":sis,
    "dia":dia,
    "pul":pul,
    "ari":ari,
    "users_permissions_user":id
  });
  print(id.toString());
  print(response.body);
  
  if(response.statusCode ==200) return true;
  return false;
}

 Future<SharedPreferences> getData() async {
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  return prefs;
}

