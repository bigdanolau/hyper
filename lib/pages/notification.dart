import 'package:alert/alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
    
class NotificationApp extends StatefulWidget {
   final titulo = new TextEditingController();
   final contenido = new TextEditingController();
  String  notificar;

  @override
  _NotificationAppState createState() => _NotificationAppState();
  
}

class _NotificationAppState extends State<NotificationApp> {
  
  void initState() {
  super.initState();
  tz.initializeTimeZones();
var initializationSettingsAndroid =new AndroidInitializationSettings('@mipmap/ic_launcher'); 
  var initializationSettingsIOs = IOSInitializationSettings();
  var initSetttings = InitializationSettings(
    android:
      initializationSettingsAndroid, iOS: initializationSettingsIOs);

  flutterLocalNotificationsPlugin.initialize(initSetttings,
      onSelectNotification: onSelectNotification);
}
  Future onSelectNotification(String payload) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
   
  }));
}
  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(title: Text('Programar recordatorio'),backgroundColor: Colors.purple,centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
             TextField(
                    controller: this.widget.titulo,
                    keyboardType:  TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'Titulo',
                    ),
            ),
            TextField(

                    controller: this.widget.contenido,
                    keyboardType:  TextInputType.multiline,
                    decoration: InputDecoration(
                      hintText: 'Contenido',
                    ),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Fecha y hora',
              
              onChanged: (val) => this.widget.notificar = val,
              validator: (val) {
                
                return null;
              },
              onSaved: (val) => this.widget.notificar = val
            ),
            SizedBox(height: 20),
            _submitButton(context)

          ],
        ),
      ),
    );
  
}
Widget _submitButton(context) {
    
    return InkWell(
      onTap: () async {
        print(this.widget.titulo.text);
        Alert(message: "Notificación Programada.");
        await scheduleNotification(this.widget.titulo?.text,this.widget.contenido?.text,this.widget.notificar);
      },      
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            ),
        child: Text(
          'Guardar',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
  Future<void> scheduleNotification(titulo,contenido,scheduledNotificationDateTime) async {
  Alert(message: "Notificación Programada.").show();
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel id',
    'channel name',
    'channel description',
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      android:
      androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.schedule(1, this.widget.titulo.text, contenido,
        DateTime.parse(scheduledNotificationDateTime), platformChannelSpecifics);
  
        this.widget.titulo.text = "";
        this.widget.contenido.text = "";
}
}

showNotification(titulo,contenido,fecha) async {
    var android = AndroidNotificationDetails(
        'id', 'channel ', 'description',
        priority: Priority.high, importance: Importance.max);
    var iOS = IOSNotificationDetails();
    var platform = new NotificationDetails(android: android,iOS:iOS);
    await flutterLocalNotificationsPlugin.show(
        0, 'Flutter devs', 'Flutter Local Notification Demo', platform,
        payload: 'Welcome to the Local Notification demo'); 
  }
  
