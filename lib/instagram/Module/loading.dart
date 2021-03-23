import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(

        child: Container(
          height: MediaQuery.of(context).size.height*0.35,
          width:  MediaQuery.of(context).size.width*0.65,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CircularProgressIndicator(),
                Text("Loading...")
              ],
            ),
          ),
          decoration: BoxDecoration(
            border: Border.all(width: 1.2, color: Colors.grey)
          ),
        ),
      ),
    );
  }
}