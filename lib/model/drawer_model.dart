

import 'package:fleva_icons/fleva_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DrawerModel{
  Widget icon;
  String title;

  DrawerModel({this.icon,this.title});
}

List<DrawerModel> drawerOptions = [
  DrawerModel(
    icon: Icon(Icons.shopping_basket),
    title: 'Order History'
  ),
  DrawerModel(
    icon: Icon(FlevaIcons.log_out),
    title: 'Log Out'
  ),
];