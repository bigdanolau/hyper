import 'package:alert/alert.dart';
import 'package:flutter/material.dart';
import 'package:hypersafe/models/medicionesModel.dart';
import 'package:hypersafe/providers/medicionesProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'notification.dart';
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<SharedPreferences> getData() async {
  SharedPreferences  prefs = await SharedPreferences.getInstance();
  return prefs;
}
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(title: Text('HyperSafe'),centerTitle: true,backgroundColor: Colors.purple,actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
          onTap:  ()async{
            String texto = "";
            await getMediciones().then((value) {
              for (var i = 0; i < value.length; i++){
                texto +=  "\n "+value[i].publishedAt.toLocal().toString()+"\n";
                texto += "\n SIS - "+value[i].sis.toString()+" DIA-"+value[i].dia.toString()+" PULSO -" +value[i].pul.toString()+" ari -"+value[i].ari.toString()+"\n";
              }
            });
            SharedPreferences pref = await getData();
            final Email email = Email(
              body: texto,
              subject: 'Envio reportes médicos',
              recipients: [pref.getString('medico')],
      
              isHTML: false,
            );

            await FlutterEmailSender.send(email);
          },
          child: Icon(Icons.send),
      ),
        ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: (){
            Navigator.push(
            context, MaterialPageRoute(builder: (context) => NotificationApp())); 
          },
          child: Icon(Icons.notification_important)
        ),
      )
      ]),
      body: SingleChildScrollView(child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height *0.90,
            child: FutureBuilder<List<MedicionesModel>>(
                future: getMediciones(),
                builder: (context, AsyncSnapshot snapshot) {
                    if(!snapshot.hasData) return Center(child: Text('No existen Datos.'));
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (BuildContext context, int index) {
                      var data = snapshot.data[index];
                      return timeline(data?.publishedAt.toLocal().toString(),data?.sis.toString(),data?.dia.toString(),data?.pul.toString(),data?.ari.toString());
                     }
                    );
                }
            ),
          )
         ],
      ),),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: (){
          _mostrarDialogo();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  
  Widget timeline(fecha,sis,dia,pulso,ari){
    return TimelineTile(
           beforeLineStyle: const LineStyle(
          color: Colors.purple,
          thickness: 6,
        ),
        indicatorStyle: const IndicatorStyle(
          width: 20,
          color: Colors.purple,
        ),
           alignment: TimelineAlign.start,
           
           endChild: Container(
    constraints: const BoxConstraints(
      minHeight: 90,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
          SizedBox(height: 5.5),
        Text(fecha),
        Container(decoration: BoxDecoration(color: Color(0xff9A70EC),borderRadius: BorderRadius.circular(8.0)),padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(child: Column(
                children: [
                  Text('SIS',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 9.0,),
                  Text(sis,style: TextStyle(color: Colors.white),)
                ],
              ),),
              Container(child: Column(
                children: [
                  Text('Dia',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 9.0,),
                  Text(dia,style: TextStyle(color: Colors.white),)
                ],
              ),),
              Container(child: Column(
                children: [
                  Text('Pulso',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 9.0,),
                  Text(pulso,style: TextStyle(color: Colors.white),)
                ],
              ),),
              Container(child: Column(
                children: [
                  Text('Aritmia',style: TextStyle(color: Colors.white),),
                  SizedBox(height: 9.0,),
                  ari == "1" ? Text('Sí',style: TextStyle(color: Colors.white),) : Text('No',style: TextStyle(color: Colors.white),)
                  
                ],
              ),)
            ],)
          )
        
      ],
    ),
  ),
         );
  }
  
  
    _mostrarDialogo() {
    final sistolica = TextEditingController();
    final diastolica = TextEditingController();
     final pulso = TextEditingController();
    final arritmia = TextEditingController();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Añadir'),
            content: Container(
                child: Wrap(
              children: [
                TextField(
                  controller: sistolica,
                  keyboardType:  TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Sistólica',
                  ),
                ),
                TextField(
                  controller: diastolica,
                  keyboardType:  TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Diastólica',
                  ),
                  
                ),
                TextField(
                  controller: pulso,
                  keyboardType:  TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Pulso',
                  ),
                  
                ),
                TextField(
                  controller: arritmia,
                  keyboardType:  TextInputType.number,
                  decoration: InputDecoration(
                    
                    hintText: 'Arritmia',
                  ),
                  
                ),
              ],
            )),
            actions: [
              MaterialButton(
                child: Text('Añadir'),
                textColor: Colors.blue,
                onPressed: () async {
                  var sis = int.parse(sistolica.text);
                  var dia = int.parse(diastolica.text);

                  if(dia <=  0 || dia >=300 || sis <=  0 || sis >=300){
                    Alert(message: "diferente a 0 y menor que 300").show();
                    return;
                  }
                  bool res = await addMediciones(sistolica.text,diastolica.text,pulso.text,arritmia.text);
                  if(res) {Alert(message: 'Registro Añadido').show();Navigator.pop(context);}
                  /*if (titulo.text != "" && contenido.text != "") {
                    preguntasProvider.addPreguntas(new Pregunta(
                        titulo: titulo.text, contenido: contenido.text));
                    await preguntasProvider.getPreguntas();
                    
                    setState(() {});
                    Navigator.pop(context);
                    
                  }*/
                },
              )
            ],
          );
        });       
  }
}