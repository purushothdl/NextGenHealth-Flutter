// lib/core/services/firebase_service.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize Firebase Messaging
  Future<void> initialize() async {
    await Firebase.initializeApp();
    await _setupFCM();
  }

  // Setup FCM configurations
  Future<void> _setupFCM() async {
    // Request notification permissions
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Configure foreground notification presentation
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      print('FCM Token Refreshed: $newToken');
      // TODO: Update token in backend (if needed)
    });
  }

  // Get current FCM token
  Future<String?> getFCMToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      print('Error getting FCM token: $e');
      return null;
    }
  }

  // Background message handler (must be static/top-level)
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    print('Handling background message: ${message.messageId}');
  }

  // Initialize notification handlers
  void setupNotificationHandlers() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('App opened via notification: ${message.notification?.title}');
    });

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }
}