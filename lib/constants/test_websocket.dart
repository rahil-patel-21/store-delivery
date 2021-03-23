import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class AnnouncementPage extends StatefulWidget {
  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  IOWebSocketChannel channel;

  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    try {
      channel = IOWebSocketChannel.connect(
          'wss://zaboreats.com/ws/driver/updatelocation');
          //wss://echo.websocket.org
          //wss://zaboreats.com/ws/driver/updatelocation
    } catch (e) {
      print(e);
    }

    // channel.stream.listen((message) {
    //   // handling of the incoming messages
    //   print(message.toString());
    // }, onError: (error, StackTrace stackTrace) {
    //   // error handling
    //   print(error.toString());
    // }, onDone: () {
    //   // communication has been closed
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Announcement Page"),
      ),
      body: Center(
          child: Column(
        children: <Widget>[
          StreamBuilder(
            stream: channel.stream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              return snapshot.hasData
                  ? Text(
                      snapshot.data.toString(),
                    )
                  : CircularProgressIndicator();
            },
          ),
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: "Enter your message here"),
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.send),
          onPressed: () {
            channel.sink.add('{"lat": 18.031375711202156, "lng": -66.587883, "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImRyaXZlcjVAbWFpbGluYXRvci5jb20iLCJ1c2VyaWQiOjE0OCwiaWF0IjoxNTkyNjU2NjI3LCJleHAiOjE1OTI3NDMwMjd9.8IC1rqhpwXskwqLpoaKOabcWbmBo22LOrxNvDtd3tD4", "user_id": 148}');
          }),
    );
  }
}
