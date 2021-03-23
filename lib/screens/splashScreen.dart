import 'dart:io';

import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:delivery_boy_app/screens/home_screen.dart';
import 'package:delivery_boy_app/screens/login_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hydrated/hydrated.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

BuildContext mainContext;

class SplashScreen extends StatefulWidget {
  static const routeName = "/";
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final isLogin$ = HydratedSubject<bool>("isLogin", seedValue: false);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool init = true;
  bool _isloading = true;
  @override
  void dispose() {
    isLogin$.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');

        if (message['aps'] != null) {
          showNotificationAlert(message['aps']['alert']['title'],
              message['aps']['alert']['body']);
        } else {
          showNotificationAlert(message['notification']['title'],
              message['notification']['body']);
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );

    _firebaseMessaging.getToken().then((token) {
      print('Firebase Token >>> ' + token);
      AppUtils.saveFirebaseDeviceToken(token);
    });

    checkLogin();
  }

  Future<void> checkLogin() async {
    User user = await AppUtils.getUser();
    String token = await AppUtils.getToken();
    if (user != null && token != null) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CupertinoActivityIndicator()),
    );
  }

  loginCheck(bool data) {
    if (data)
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    else
      Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
    init = false;
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  showNotificationAlert(String title, String body) async {
    await showDialog(
        context: mainContext,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text('$body'),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
