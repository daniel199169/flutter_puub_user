import 'package:Puub/services/authentication/puub_auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class PuubPushNotificationsService {
  String uid;
  PuubPushNotificationsService._();

  factory PuubPushNotificationsService() => _instance;

  static final PuubPushNotificationsService _instance =
      PuubPushNotificationsService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;
  TextEditingController _controller = new TextEditingController();
  PuubAuthService pServ = PuubAuthService();
  String token1;

  Future<void> init(String uid) async {
    if (!_initialized) {
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure();
      String token = await _firebaseMessaging.getToken();
      token1 = token;
      print("FirebaseMessaging token: $token");
      await pServ.updateMessagingToken(token, uid);
      //_insert(token, "yyy ", "hhh");
      _initialized = true;
    }
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print('myBackgroundMessageHandler====');
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  Future<void> config(Function f, BuildContext context) async {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("KKKKonMessage: $message");
        },
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunchDDDD: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResumeFFFF: $message");
        },
        onBackgroundMessage: myBackgroundMessageHandler);
  }
}
