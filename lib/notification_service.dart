import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:finak/config/routes/app_routes.dart';
import 'package:finak/core/preferences/preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  /// Global Key for Navigation
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Firebase Messaging Instance
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  /// Local Notifications Plugin
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _notificationCounter = 0;
  bool isWithNotification = false;
  String notificationId = "0";
  String notificationType = "";

  /// **Initialize Notifications**
  Future<void> initialize() async {
    await _initializeFirebaseMessaging();
    await _initializeLocalNotifications();
  }

  /// **Firebase Messaging Initialization**
  Future<void> _initializeFirebaseMessaging() async {
    // Handle when app is completely closed and opened via notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      isWithNotification = true;
      notificationType = initialMessage.data['type'] ?? "";
      notificationId = initialMessage.data['id'] ?? "-1";
    }

    // Handle notification click when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
    });

    // Request notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((message) {
      print("Foreground Message Received: ${message.notification?.title}");
      print("Message Data: ${message.data}");

      navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);

      _showLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: message.data.toString(),
      );
    });

    await _getToken();
  }

  /// **Handles Background Notifications**
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print("Background Message Received: ${message.notification?.title}");
  }

  /// **Fetches and Stores FCM Token**
  Future<void> _getToken() async {
    try {
      String token = await _messaging.getToken() ?? '';
      print("FCM Token: $token");
      Preferences.instance.setNotificationToken(value: token);
    } catch (e) {
      print("Error getting token: $e");
    }
  }

  /// **Local Notifications Initialization**
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
      },
    );

    if (Platform.isAndroid) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }

    if (Platform.isIOS) {
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  /// **Shows a Local Notification**
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      ticker: 'ticker',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      _notificationCounter++,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }
}
