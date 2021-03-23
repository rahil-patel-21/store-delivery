import 'dart:convert';

import 'package:delivery_boy_app/constants/shared_pref_constant.dart';
import 'package:delivery_boy_app/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUtils {
  static void saveFirebaseDeviceToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.deviceToken, token);
  }

  static Future<String> getDeviceToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(SharedPrefKeys.deviceToken) == null
        ? ''
        : pref.getString(SharedPrefKeys.deviceToken);
  }

  static void saveUser(User userModel) async {
    final pref = await SharedPreferences.getInstance();
    Map<String, dynamic> json = userModel.toJson();
    pref.setString(SharedPrefKeys.userModel, jsonEncode(json));
    pref.setBool(SharedPrefKeys.userLoggedIn, true);
  }

  static void saveMyServiceStatus(bool status) async {
    final pref = await SharedPreferences.getInstance();
    pref.setBool(SharedPrefKeys.myService, status);
  }

  static Future<bool> getMyServiceStatus() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(SharedPrefKeys.myService) == null
        ? false
        : pref.getBool(SharedPrefKeys.myService);
  }

  static void saveToken(String token) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(SharedPrefKeys.userAccessToken, token);
  }

  static Future<String> getToken() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(SharedPrefKeys.userAccessToken) == null
        ? ''
        : pref.getString(SharedPrefKeys.userAccessToken);
  }

  static void logout() async {
    final pref = await SharedPreferences.getInstance();
    pref.remove(SharedPrefKeys.userLoggedIn);
    pref.remove(SharedPrefKeys.userModel);
    pref.remove(SharedPrefKeys.userAccessToken);
    pref.remove(SharedPrefKeys.isLogin);
  }

  static Future<User> getUser() async {
    final pref = await SharedPreferences.getInstance();
    final jsonString = pref.getString(SharedPrefKeys.userModel);
    if (jsonString == null) {
      pref.setBool(SharedPrefKeys.userLoggedIn, false);
      return null;
    }
    final json = jsonDecode(jsonString);
    final user = User.fromJson(json);
    return user;
  }
}
