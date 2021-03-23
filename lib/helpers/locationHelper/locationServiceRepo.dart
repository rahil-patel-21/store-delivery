import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:background_locator/location_dto.dart';
import 'package:delivery_boy_app/constants/api_constant.dart';
import 'package:delivery_boy_app/helpers/app_utils.dart';
import 'package:delivery_boy_app/model/login_model.dart';

import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:web_socket_channel/io.dart';

class LocationServiceRepository {
  static LocationServiceRepository _instance = LocationServiceRepository._();

  LocationServiceRepository._();

  factory LocationServiceRepository() {
    return _instance;
  }

  static const String isolateName = 'LocatorIsolate';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int _count = -1;
  User user;
  String token;
  showNotification(Map<String, dynamic> msg, {bool isTesting = false}) async {
    var android = AndroidNotificationDetails(
        "channel_id", "CHANNEL NAME", "channelDescription");
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android, ios);

    await flutterLocalNotificationsPlugin.show(
        0,
        isTesting ? "I am Testing" : msg['title'],
        isTesting ? "I am Testing" : msg['body'],
        platform);
  }

  Future<void> init(Map<dynamic, dynamic> params) async {
    print("***********Init callback handler");
    if (params.containsKey('countInit')) {
      dynamic tmpCount = params['countInit'];
      if (tmpCount is double) {
        _count = tmpCount.toInt();
      } else if (tmpCount is String) {
        _count = int.parse(tmpCount);
      } else if (tmpCount is int) {
        _count = tmpCount;
      } else {
        _count = -2;
      }
    } else {
      _count = 0;
    }
    print("$_count");
    await setLogLabel("start");
    await initDeps();
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  initDeps() async {
    user = await AppUtils.getUser();
    token = await AppUtils.getToken();
    String deviceToken = await AppUtils.getDeviceToken();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings("mipmap/ic_launcher");
    var ios = IOSInitializationSettings();
    var platform = InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
  }

  Future<void> dispose() async {
    print("***********Dispose callback handler");
    print("$_count");
    await setLogLabel("end");
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(null);
  }

  Future<void> callback(LocationDto locationDto) async {
    print('$_count location in dart: ${locationDto.toString()}');
    await setLogPosition(_count, locationDto);
    if (user == null) await initDeps(); 
    var data =
        '{"lat": ${locationDto.latitude}, "lng": ${locationDto.longitude}, "token": "${token}", "user_id": ${user.id}}';
    print(data);

    final channel = IOWebSocketChannel.connect(Apis.updatelocation);

    channel.stream.listen((message) {
      print('response from websocket => ' + message);
    });

    channel.sink.add(data);

    // showNotification({"title":"title", "body":"body"});
    final SendPort send = IsolateNameServer.lookupPortByName(isolateName);
    send?.send(locationDto);
    _count++;
  }

  static Future<void> setLogLabel(String label) async {
    final date = DateTime.now();
    print("date $date");
  }

  static Future<void> setLogPosition(int count, LocationDto data) async {
    final date = DateTime.now();
    print("date $date");
  }

  static double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }
}
