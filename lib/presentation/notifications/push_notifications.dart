import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class PushNotificationsProvider extends StatefulWidget {
  final Widget child;
  

  PushNotificationsProvider({required this.child});


  @override
  _PushNotificationsProviderState createState() => _PushNotificationsProviderState();
}

class _PushNotificationsProviderState extends State<PushNotificationsProvider> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  



  @override
  void initState() {
    
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    
    


    Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
        
    
    }
    
    flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails()
    .then((value) {
      if (value?.didNotificationLaunchApp ?? false) {

        var payload = value!.payload; 
         
        print(payload);
      }
    });




    Future<void> onSelectNotification(String? body) async {
        var payload = body; 
         
        print(payload);
    }
    
    
    
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);



    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage value) {
      print(value);
    });


    String createMessagePayload(RemoteMessage value) {
      print(value);


      return '';

    }




    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if (shouldShowNotification(message)) {
        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  'romanov_club_channel', // id
                  'High Importance Notifications', // title
                  channelDescription: 'Этот канал используюется для оповещений', 
                ),
              ),
              payload: createMessagePayload(message)
              );
        }
      }


    });
    
    super.initState();
  }


  bool shouldShowNotification(RemoteMessage message) {

    RemoteNotification? notification = message.notification;


    if(notification != null) {

      print(message);

    }

    return false;


  }





  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}