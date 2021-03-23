import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:delivery_boy_app/instagram/Module/auth_window.dart';
import 'package:delivery_boy_app/instagram/Module/loading.dart';
import 'package:delivery_boy_app/instagram/constants.dart';
import 'package:delivery_boy_app/model/token.dart';
import 'package:delivery_boy_app/model/username.dart';
import 'package:delivery_boy_app/model/userprofile.dart';
import 'package:http/http.dart' as http;

Future<Token> getToken(
    String appId, String appSecret, BuildContext context) async {
  String url =
      "https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=${Constants.authUrl}&scope=user_profile,user_media&response_type=code";

 String authCode = await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AuthWindow(
            url: url,
          )));
  
  print("closing webview");
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => Loading()));

  final http.Response response =
      await http.post("https://api.instagram.com/oauth/access_token", body: {
    "client_id": appId,
    "redirect_uri":
      Constants.authUrl,
    "client_secret": appSecret,
    "code": authCode,
    "grant_type": "authorization_code"
  });
  print(response.body);
  print("closinbg webview");
  Navigator.of(context).pop();
  return new Token.fromMap(json.decode(response.body));
}

Future<UserName> getUsername(Token token) async {
http.Response response = await http.get(
               'https://graph.instagram.com/me?fields=id,username&access_token=${token.access}');
print("FDgfgh"+response.body);
  return UserName.fromJson(json.decode(response.body));
}
Future<UserProfile> getProfile( UserName username) async {
http.Response response = await http.get(
               'https://www.instagram.com/${username.username}/?__a=1');
print(response.body);
Map<String,dynamic> responsed = json.decode(response.body);
  return UserProfile.fromJson({"profilePic":responsed['graphql']['user']['profile_pic_url_hd'] ,
  "userId": username.id,
  "userName":responsed['graphql']['user']['username'],
  "fullName":responsed['graphql']['user']['full_name']
   });
}

