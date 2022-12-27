import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSImage extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color lightColor;
  final Color darkColor;
  final Color color;

  NSImage({
    this.image,
    this.color,
    this.lightColor,
    this.darkColor,
  });

  @override
  Widget build(BuildContext context) {
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? (lightColor ?? color)
        : (darkColor ?? color);

    Widget ios = Image(image: image, color: _color);

    Widget android = Image(image: image, color: _color);

    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
