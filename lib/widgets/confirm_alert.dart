import 'package:flutter/material.dart';

class BaseAlertDialog extends StatelessWidget {

  Color _color = Color.fromARGB(220, 117, 218 ,255);

  String _title;
  String _content;
  String _yes;
  String _no;
  Function _yesOnPressed;
  Function _noOnPressed;

  BaseAlertDialog({String title, String content, Function yesOnPressed, Function noOnPressed, String yes = "Yes", String no = "No"}){
    this._title = title;
    this._content = content;
    this._yesOnPressed = yesOnPressed;
    this._noOnPressed = noOnPressed;
    this._yes = yes;
    this._no = no;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(this._title),
      content: new Text(this._content),
      backgroundColor: Colors.yellow,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
      actions: <Widget>[
        new FlatButton(
          child: new Text(this._yes),
          textColor: Colors.black,
          onPressed: () {
            this._yesOnPressed();
          },
        ),
        new FlatButton(
          child: Text(this._no),
          textColor: Colors.black,
          onPressed: () {
            this._noOnPressed();
          },
        ),
      ],
    );
  }
}