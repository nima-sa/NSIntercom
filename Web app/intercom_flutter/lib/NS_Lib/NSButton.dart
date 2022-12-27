import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSButton extends StatelessWidget {
  final Widget body;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;
  // final EdgeInsetsGeometry androidPadding;
  final MaterialTapTargetSize materialTapTargetSize;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final Color disabledColor;
  final num pressedOpacity;
  final BorderRadius borderRadius;
  final bool ignoresColorIfNull;
  final Color androidSplashColor;
  final Color borderColor;
  final Color lightBorderColor;
  final Color darkBorderColor;
  final double borderWidth;

  NSButton({
    Key key,
    @required this.body,
    this.padding,
    // this.androidPadding,
    this.materialTapTargetSize,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.onLongPress,
    this.lightColor,
    this.darkColor,
    this.ignoresColorIfNull = false,
    this.androidSplashColor,
    this.borderColor,
    this.borderWidth = 0,
    this.lightBorderColor,
    this.darkBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color _color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (lightColor ?? color)
            : (darkColor ?? color);

    final Color _borderColor =
        (MediaQuery.of(context).platformBrightness == Brightness.light
                ? (lightBorderColor ?? borderColor)
                : (darkBorderColor ?? borderColor)) ??
            Colors.transparent;

    Widget ios = Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: _borderColor, width: borderWidth),
      ),
      child: CupertinoButton(
        child: body,
        padding: padding,
        color: _color,
        disabledColor: disabledColor,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        onPressed: onPressed,
      ),
    );
    Widget android = TextButton(
      style: TextButton.styleFrom(
        onSurface: androidSplashColor,
        padding: padding,
        tapTargetSize: materialTapTargetSize,
        backgroundColor: _color,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: _borderColor, width: borderWidth),
        ),
      ),
      // splashColor: androidSplashColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: borderRadius,
      //   side: BorderSide(color: _borderColor, width: borderWidth),
      // ),
      child: body,
      // materialTapTargetSize: materialTapTargetSize,
      onPressed: onPressed,
      onLongPress: onLongPress,
      // padding: padding,
      // color: _color,
    );

    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
