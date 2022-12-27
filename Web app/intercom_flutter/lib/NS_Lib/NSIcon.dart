import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSIcon extends StatelessWidget {
  final IconData icon;
  final Color lightColor;
  final Color darkColor;
  final Color color;

  NSIcon(
    this.icon, {
    Key key,
    this.lightColor,
    this.darkColor,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? (lightColor ?? color)
        : (darkColor ?? color);

    Widget ios = Icon(icon, color: _color, size: 25);

    Widget android = Icon(icon, color: _color);

    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
