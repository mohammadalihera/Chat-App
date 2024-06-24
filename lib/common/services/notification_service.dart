import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class FirebaseNotificationService {
  late FirebaseMessaging _firebaseMessaging;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  FirebaseNotificationService._internal() {
    _firebaseMessaging = FirebaseMessaging.instance;

    firebaseFcmConfig();
    fcmListeners();
  }

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'chat_app_default_channel', // id
    'Chat App Default Channel', // title
    description: 'This channel is used for Chat default notifications.', // description
    importance: Importance.high,
  );

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        // channelDescription: channel.description,
      ),
    );
  }

  firebaseFcmConfig() async {
    await FirebaseMessaging.instance.getInitialMessage();
    await FirebaseMessaging.instance.requestPermission();
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    const _initializationSettingsIOS = DarwinInitializationSettings();

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: _initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static final FirebaseNotificationService _instance = FirebaseNotificationService._internal();

  static FirebaseNotificationService get instance {
    return _instance;
  }

  static String constructFCMPayload({required String token, required String title, required String body}) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'Chat App',
      },
      'notification': {
        'title': title,
        'body': body,
      },
    });
  }

  static Future<void> sendPushMessage({String? token, required String title, required String body}) async {
    if (token == null) {
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(token: token, title: title, body: body),
      );
    } catch (e) {}
  }

  void fcmListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      flutterLocalNotificationsPlugin.show(
          notification.hashCode, notification?.title, notification?.body, _notificationDetails());
    });
  }
}
