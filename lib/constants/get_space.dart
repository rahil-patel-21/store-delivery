import 'package:flutter/material.dart';

class GetVSpace extends StatelessWidget {
  final double space;

  const GetVSpace({Key key, this.space = 10.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: space,
    );
  }
}

class GetHSpace extends StatelessWidget {
  final double space;

  const GetHSpace({Key key, this.space = 10.0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: space,
    );
  }
}