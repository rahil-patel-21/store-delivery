import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:delivery_boy_app/instagram/Module/instagramauth.dart';


class AuthWindow extends StatefulWidget {
 final String url ;
  AuthWindow({Key key , this.url}) : super(key: key);

  @override
  _AuthWindowState createState() => _AuthWindowState();
}

class _AuthWindowState extends State<AuthWindow> {


  @override
  Widget build(BuildContext context) {
  String url =
      widget.url;
    InstagramAuth().signInWithInstagram(context);

    return WebviewScaffold(
      url: url,
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Text('Login to Instagram', style: TextStyle(color: Colors.white),),
      ),
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
    );
  }
}