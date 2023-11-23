import 'dart:convert';

import 'package:firebasepractice/notification/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.foregroundMessage(); 
    // notificationServices.isTokenRefresh();
    notificationServices.getDeviceToken().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('notification'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('confirm'),
            onPressed: () {
              notificationServices.getDeviceToken().then((value) async {
                var data = {
                  'to': value.toString(),
                  'priority': 'high',
                  'subtitle': 'hey',
                  'notification': {
                    'title': 'manish',
                    'body': 'Notification send by manish',
                  },
                  'data': {'id': '1123', 'name': 'oppo'}
                };
                await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
                    body: jsonEncode(data),
                    headers: {
                      'Content-Type': 'application/json;charset=UTF-8',
                      'Authorization':
                          'key=AAAAxF3xk-A:APA91bGZ2eLreJtJkeNNC1Al1pL83ZuRvJ4Dpb9NPAZ_kK4PaWwtvWmbPQmtj9pKkXb_d3yMcpZj1FEGv4lmucsMRFDQrr11rzWkD3u76ubvP3Ohqe1OQ3nVz0txT1BkPnePMIf9-G27'
                    });
              });
            },
          ),
        ));
  }
}
