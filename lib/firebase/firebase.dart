import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:lseway/data/data-sources/user/user_local_data_source.dart';

class LocalFirebase {
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {

    await Firebase.initializeApp();
    print('Handling a background message ${message.messageId}');
  }

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'e_way_channel', // id
    'High Importance Notifications', // title
    description: 'Этот канал используюется для оповещений', // description
    importance: Importance.high,
    
  );

  static Future<FirebaseApp> init() async {
    FirebaseApp app = await Firebase.initializeApp();
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.instance.requestPermission();

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    try {
      var box = Hive.box('session');

      var token = await FirebaseMessaging.instance.getToken();

      box.put('device_token', token);
      // box.delete("80PercentShown79859153858");


      // var shown = UserLocalDataSource().get80PercentShown('79859153858');

      // print(shown);
    } catch (err) {
      print(err);
    }

    return app;
  }
}
