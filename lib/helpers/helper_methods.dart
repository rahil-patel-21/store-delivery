import 'package:flutter/material.dart';

class HelperMethods {
  static void showSnackBar(BuildContext context, String message,
      GlobalKey<ScaffoldState> _scaffoldkey, SnackBarAction action) {
    _scaffoldkey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      action: action,
    ));
  }
}
