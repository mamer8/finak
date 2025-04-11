import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:finak/features/chat/screens/chat_screen.dart';
import 'package:finak/features/services/data/models/get_services_model.dart';
import 'package:finak/features/services/screens/services_details_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:finak/config/routes/app_routes.dart';
import 'package:finak/core/preferences/preferences.dart';
 
   RemoteMessage? initialMessageRecieved;
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
      initialMessageRecieved = initialMessage;
    
    }

    // Handle notification click when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (message.data['reference_table'] == "offers") {
        navigatorKey.currentState?.pushNamed(Routes.servicesDetailsRoute,
            arguments: ServiceDetailsArgs(
              serviceModel: ServiceModel(
                id: int.tryParse(message.data['reference_id']),
              ),
            ));
      } else if (message.data['reference_table'] == "rooms") {
        navigatorKey.currentState?.pushNamed(Routes.chatRoute,
            arguments: ChatScreenArguments(
                int.tryParse(message.data['reference_id']) ?? 0,
                message.notification?.title ?? "",
                isFromNotifation: true));
      } else {
        navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
      }
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

      /// Check if the message is from a chat room
      final roomId = message.data['reference_id']?.toString();

      if (MessageStateManager().isInChatRoom("0")) {
        log("Already in chat room $roomId - skipping notification");
        return;
      }
      // if (MessageStateManager().isInChatRoom(roomId)) {
      //   log("Already in chat room $roomId - skipping notification");
      //   return;
      // }

      _showLocalNotification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
        payload: jsonEncode(message.data), // message.data.toString(),
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
        final payload = details.payload;
        log('Notification payload: $payload');

        try {
          if (payload != null) {
            Map<String, dynamic> message;
            // try {
            message = jsonDecode(payload);
            // } catch (e) {
            //   final cleanPayload =
            //       payload.replaceAll('{', '').replaceAll('}', '');
            //   final pairs = cleanPayload.split(',');

            //   message = {};
            //   for (var pair in pairs) {
            //     final keyValue = pair.split(':');
            //     if (keyValue.length == 2) {
            //       final key = keyValue[0].trim();
            //       final value = keyValue[1].trim();
            //       message[key] = value;
            //     }
            //   }
            // }

            log('Notification message after parsing: $message');

            if (message['reference_table'] == "offers") {
              navigatorKey.currentState?.pushNamed(Routes.servicesDetailsRoute,
                  arguments: ServiceDetailsArgs(
                    serviceModel: ServiceModel(
                      id: int.tryParse(message['reference_id'].toString()),
                    ),
                  ));
            } else if (message['reference_table'] == "rooms") {
              navigatorKey.currentState?.pushNamed(Routes.chatRoute,
                  arguments: ChatScreenArguments(
                      int.tryParse(message['reference_id'].toString()) ?? 0,
                      message['sender_name'] ?? "",
                      isFromNotifation: true));
            } else {
              navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
            }
          } else {
            // Default action if payload is null
            navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
          }
        } catch (e) {
          log('Error parsing notification payload: $e');
          // Fallback action
          navigatorKey.currentState?.pushNamed(Routes.notificationsRoute);
        }
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

class MessageStateManager {
  static final MessageStateManager _instance = MessageStateManager._internal();
  factory MessageStateManager() => _instance;
  MessageStateManager._internal();

  // Track active chat room IDs
  final Set<String> _activeChatRoomIds = {};

  // Methods to update state
  void enterChatRoom(String roomId) {
    _activeChatRoomIds.add(roomId);
    log("Entered chat room: $roomId");
  }

  void leaveChatRoom(String roomId) {
    _activeChatRoomIds.remove(roomId);
    log("Left chat room: $roomId");
  }

  // Check if we're in a specific chat room
  bool isInChatRoom(String? roomId) {
    return roomId != null && _activeChatRoomIds.contains(roomId);
  }
}
