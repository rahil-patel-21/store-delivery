
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class InstagramAuth with ChangeNotifier {
  
  String accessToken = "";
  static final InstagramAuth _singleton = new InstagramAuth._();

  factory InstagramAuth() => _singleton;

  InstagramAuth._();

  Future<void> signInWithInstagram(BuildContext context) async {
    final flutterWebviewPlugin = new FlutterWebviewPlugin();
     
    flutterWebviewPlugin.onUrlChanged.listen((String url) async {
      print(url);
      if (url.contains('auth?code=')) {
        // save access token for later logins
        var _accessToken = url.split('auth?code=')[1].replaceFirst('#_', '');            
        await flutterWebviewPlugin.cleanCookies();
        await flutterWebviewPlugin.close();

        // pop the webview Scaffold and immediately enter the picker
        Navigator.pop(context, _accessToken);
      }
    });
  }
}