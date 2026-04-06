import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/order_screen.dart';

import 'main.dart';

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  final localNotifications = FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const settings = InitializationSettings(android: androidSettings);
  await localNotifications.initialize(settings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'channel_id',
    'channel_name',
    description: 'channel_description',
    importance: Importance.max,
  );

  await AndroidFlutterLocalNotificationsPlugin()
      .createNotificationChannel(channel);

  const androidDetails = AndroidNotificationDetails(
    'channel_id',
    'channel.name',
    channelDescription: 'channel.description',
    importance: Importance.max,
    priority: Priority.high,
  );

  const details = NotificationDetails(android: androidDetails);

  await localNotifications.show(
    message.hashCode,
    message.notification?.title ?? "No Title",
    message.notification?.body,
    details,
  );

  log("Background Message displayed: ${message.notification?.title}");
}

class SimpleFCMService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    await _messaging.requestPermission(
        alert: true, sound: true, badge: true);

    const androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;

        if (payload != null) {
          _handleNavigation(payload);
        }
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'channel_description',
      importance: Importance.max,
    );

    await AndroidFlutterLocalNotificationsPlugin()
        .createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    final token = await _messaging.getToken();
    log("FCM Token: $token");

    FirebaseMessaging.onMessage.listen((message) {
      log('Foreground Message received: ${message.notification?.title}');

      final screen = message.data['screen'];
      final id = message.data['id'];

      _showNotification(
        title: message.notification?.title ?? "No Title",
        body: message.notification?.body ?? "",
        payload:  "$screen|$id",

      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("onMessageOpenedApp triggered");

      final data = message.data;

      _handleNavigation("${data['screen']}|${data['id']}");
    });
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel.name',
      channelDescription: 'channel.description',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _localNotifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload
    );
  }

  void _handleNavigation(String payload) {
    final parts = payload.split('|');

    final screen = parts[0];
    final id = parts.length > 1 ? parts[1] : null;

    if (screen == "order") {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => OrderScreen(orderId: id),
        ),
      );
    }
  }


  Future<void> handleInitialMessage() async {
    final initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      log("App opened from terminated state");

      final data = initialMessage.data;
      print("Initial Message Data: $data");
      _handleNavigation("${data['screen']}|${data['id']}");
    }
  }

}