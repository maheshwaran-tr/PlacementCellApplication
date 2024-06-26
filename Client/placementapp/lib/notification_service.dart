import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:placementapp/backend/token/token_storage.dart';
import 'package:placementapp/main.dart';
import 'firebase_analytics_service.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationService {
  Future<void> initialize() async {
    FirebaseMessaging.instance.getToken().then((value) async {
      print("getToken : $value");
      TokenStorage.saveFCMToken(value);
      print(TokenStorage.getFCMToken());
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print({"message": json.encode(message.data)});
      // Show local notification
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp : $message");
      runApp(App());
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
            arguments: {"message": json.encode(message.data)});
        FirebaseAnalyticsService.logEvent(
            name: 'initial_message_received', parameters: message.data);
      }
    });

    FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingOnBackgroundHandler);
  }
}

Future<void> _firebaseMessagingOnBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("FROM BG NOTI");
  print("_firebaseMessagingOnBackgroundHandler: ${message}");
}
