import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web2app/home_screen.dart';
import 'package:web2app/user_model.dart';

class NotificationServices {
  late UserModel user;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
    enableLights: true,
  );
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("User denied permission");
    }
  }

  // Initialize local notifications
  Future<void> initLocalNotification(
      BuildContext context, RemoteMessage message, UserModel user) async {
    if (_firebaseAuth.currentUser != null) {
      var androidInitializationSettings =
          const AndroidInitializationSettings("@mipmap/ic_launcher");

      var initializationSetting =
          InitializationSettings(android: androidInitializationSettings);
      await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
          onDidReceiveNotificationResponse: (payload) async {
        handleMessage(context, message, user);
      });
    }
  }

  // Schedule token refresh periodically
  void startTokenRefreshPeriodically() {
    const refreshDuration = Duration(days: 1);
    Timer.periodic(refreshDuration, (_) {
      isTokenRefresh();
    });
  }

  // Show notification using local notifications
  void showNotification(RemoteMessage message) async {
    if (_firebaseAuth.currentUser != null) {
      await _flutterLocalNotificationsPlugin.show(
        message.notification!.hashCode,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: Colors.teal,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            priority: Priority.max,
            enableVibration: true,
          ),
        ),
      );
    }
  }

  // Initialize Firebase messaging
  void firebaseInit(BuildContext context, UserModel model) {
    user = model;
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (_firebaseAuth.currentUser != null) {
        showNotification(message);
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        initLocalNotification(context, message, user);
      }
    });
  }

  // Get device token from Firebase
  void getDeviceToken() async {
    String? token = await messaging.getToken();
    print("Device Token:");
    print(token);
    saveToken(token!);
  }

  // Listen for token refresh and save new token
  void isTokenRefresh() {
    messaging.onTokenRefresh.listen((event) {
      print("Token refreshed");
      print(event);
      deleteToken();
      getDeviceToken();
      saveToken(event);
    });
  }

  // Save device token to Firestore and send it to the server
  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc(_firebaseAuth.currentUser!.email)
        .set({'token': token});
  }

  // Delete device token from Firestore
  void deleteToken() async {
    await FirebaseFirestore.instance
        .collection("userTokens")
        .doc(_firebaseAuth.currentUser!.email)
        .delete();
  }

  // Handle incoming notification messages
  void handleMessage(
    BuildContext context,
    RemoteMessage message,
    UserModel user,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(user: user),
      ),
    );
  }

  // Setup message handling when the app is in the background or terminated
  Future<void> setupInteractMessage(BuildContext context) async {
    if (_firebaseAuth.currentUser != null) {
      // When app is terminated
      RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();

      if (initialMessage != null) {
        handleMessage(context, initialMessage, user);
      }

      // When app is running in the background
      FirebaseMessaging.onMessageOpenedApp.listen((event) {
        handleMessage(context, event, user);
      });
    }
  }
}
