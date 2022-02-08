import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FirebaseMessaging _fcm = FirebaseMessaging.instance;
FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

initializeMessaging() async {
  await Firebase.initializeApp();
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");
  final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectionNotification);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("onMessage: $message");
    await handleMessage(message);
  });
}

Future<dynamic> selectionNotification(String payload) async {
  print('payload: $payload');
}

handleMessage(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('CHAT', "CHAT", 'CHAT', importance: Importance.max, priority: Priority.high, showWhen: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(0, "New Messages", message.data['sender'] + ": " + message.data['message'], platformChannelSpecifics,
      payload: 'CHAT');
}

Future<String> getFCMToken() async {
  return await _fcm.getToken();
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await initializeMessaging();
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('CHAT', "CHAT", 'CHAT', importance: Importance.max, priority: Priority.high, showWhen: true);
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await _flutterLocalNotificationsPlugin.show(0, "New Messages", message.data['sender'] + ": " + message.data['message'], platformChannelSpecifics,
      payload: 'CHAT');
}
