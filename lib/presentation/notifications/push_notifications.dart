import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lseway/presentation/bloc/activePoints/active_points_bloc.dart';
import 'package:lseway/presentation/bloc/dialog/dialog.bloc.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointInfo.event.dart';
import 'package:lseway/presentation/bloc/pointInfo/pointinfo.bloc.dart';

class PushNotificationsProvider extends StatefulWidget {
  final Widget child;

  PushNotificationsProvider({required this.child});

  @override
  _PushNotificationsProviderState createState() =>
      _PushNotificationsProviderState();
}

class _PushNotificationsProviderState extends State<PushNotificationsProvider> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    Future<void> onDidReceiveLocalNotification(
        int id, String? title, String? body, String? payload) async {}

    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      if (value?.didNotificationLaunchApp ?? false) {
        var payload = value!.payload;

        
      }
    });

    Future<void> onSelectNotification(String? body) async {
      var payload = body;

      if (payload == '80%') {
        var chargingPoint =
            BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;
        var is80DialogShown =
            BlocProvider.of<DialogBloc>(context).state.is80DialogShown;
        if (chargingPoint != null && !is80DialogShown) {
          BlocProvider.of<PointInfoBloc>(context)
              .add(ShowPoint(pointId: chargingPoint));
        }
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage value) {
      if (value.data['message'] == "Charge reached 80 percent") {
        var chargingPoint =
            BlocProvider.of<ActivePointsBloc>(context).state.chargingPoint;
        var is80DialogShown =
            BlocProvider.of<DialogBloc>(context).state.is80DialogShown;
        if (chargingPoint != null && !is80DialogShown) {
          BlocProvider.of<PointInfoBloc>(context)
              .add(ShowPoint(pointId: chargingPoint));
        }
      }
    });

    String createMessagePayload(RemoteMessage value) {
     

      if (value.data['message'] == "Charge reached 80 percent") {
        return '80%';
      }

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
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  'e_way_channel', // id
                  'High Importance Notifications', // title
                  channelDescription: 'Этот канал используюется для оповещений',
                ),
              ),
              payload: createMessagePayload(message));
        }
      }
    });

    super.initState();
  }

  bool shouldShowNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;

    if (notification != null) {
     
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
