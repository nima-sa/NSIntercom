import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSRaisedButton extends StatelessWidget {
  final Widget body;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final Color disabledColor;
  final num pressedOpacity;
  final BorderRadius borderRadius;
  final Color androidSplashColor;
  final Color borderColor;
  final double borderWidth;

  static NSRaisedButton stdPadd({
    @required body,
    padding = const EdgeInsets.fromLTRB(0, 16, 0, 16),
    color,
    disabledColor = CupertinoColors.quaternarySystemFill,
    pressedOpacity = 0.4,
    borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required onPressed,
    onLongPress,
    lightColor,
    darkColor,
    androidSplashColor,
    borderColor = Colors.transparent,
  }) {
    return NSRaisedButton(
      body: body,
      padding: padding,
      color: color,
      disabledColor: disabledColor,
      pressedOpacity: pressedOpacity,
      borderRadius: borderRadius,
      onPressed: onPressed,
      onLongPress: onLongPress,
      lightColor: lightColor,
      darkColor: darkColor,
      androidSplashColor: androidSplashColor,
      borderColor: borderColor,
    );
  }

  static NSRaisedButton inverted({
    @required body,
    padding = const EdgeInsets.fromLTRB(0, 16, 0, 16),
    color,
    disabledColor = CupertinoColors.quaternarySystemFill,
    pressedOpacity = 0.4,
    borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required onPressed,
    onLongPress,
    lightColor,
    darkColor,
    androidSplashColor,
    borderColor,
    double borderWidth = 1,
  }) {
    return NSRaisedButton(
      body: body,
      padding: padding,
      color: color,
      disabledColor: disabledColor,
      pressedOpacity: pressedOpacity,
      borderRadius: borderRadius,
      onPressed: onPressed,
      onLongPress: onLongPress,
      lightColor: darkColor,
      darkColor: lightColor,
      androidSplashColor: androidSplashColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
    );
  }

  NSRaisedButton kInverted() {
    return NSRaisedButton(
        body: body,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        onPressed: onPressed,
        onLongPress: onLongPress,
        lightColor: darkColor,
        darkColor: lightColor,
        androidSplashColor: androidSplashColor,
        borderColor: borderColor);
  }

  NSRaisedButton({
    Key key,
    @required this.body,
    this.padding,
    this.color,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.onLongPress,
    this.lightColor,
    this.darkColor,
    this.androidSplashColor,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    final Color _color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (lightColor ?? color)
            : (darkColor ?? color);

    final shadowColor = Color.fromRGBO(0, 0, 0, 0.4);

    Widget ios = Container(
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned(
            top: 5,
            bottom: 5,
            left: 5,
            right: 5,
            child: Container(
              decoration: BoxDecoration(
                // color: Colors.red,
                borderRadius: borderRadius,
                border: Border.all(
                    color: borderColor ?? Colors.transparent,
                    width: borderWidth),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 7,
                    spreadRadius: 5,
                    offset: Offset(0, 4),
                  )
                ],
              ),
            ),
          ),
          CupertinoButton(
            child: body,
            padding: padding,
            // padding: EdgeInsets.symmetric(
            // horizontal: padding.horizontal,
            // vertical: padding.vertical - 14),
            color: _color,
            disabledColor: disabledColor,
            pressedOpacity: pressedOpacity,
            borderRadius: borderRadius,
            onPressed: onPressed,
          ),
        ],
      ),
    );

    // Padding(
    //   padding: EdgeInsets.only(top: 4.0),
    //   child: ClipRRect(
    //     // borderRadius: BorderRadius.only(
    //     //   topLeft: borderRadius.topLeft,
    //     //   topRight: borderRadius.topRight,
    //     // ),
    //     child: Padding(
    //       padding: EdgeInsets.only(bottom: 4.0),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           borderRadius: borderRadius,
    //           border: Border.all(
    //               color: borderColor ?? Colors.transparent, width: borderWidth),
    //           boxShadow: [
    //             BoxShadow(
    //               color: shadowColor,
    //               blurRadius: 1,
    //               spreadRadius: 1,
    //               offset: Offset(0, 0),
    //             )
    //           ],
    //         ),
    //         child: CupertinoButton(
    //           child: body,
    //           padding: padding,
    //           color: _color,
    //           disabledColor: disabledColor,
    //           pressedOpacity: pressedOpacity,
    //           borderRadius: borderRadius,
    //           onPressed: onPressed,
    //         ),
    //       ),
    //     ),
    //   ),
    // );

    // Widget ios = CupertinoButton(
    //   child: body,
    //   padding: padding,
    //   color: _color,
    //   disabledColor: disabledColor,
    //   pressedOpacity: pressedOpacity,
    //   borderRadius: borderRadius,
    //   onPressed: onPressed,
    // );

    Widget android = ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: padding,
        primary: _color,
        onPrimary: androidSplashColor,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: borderWidth,
          ),
        ),
      ),
      // color: _color,
      // splashColor: androidSplashColor,
      // shape: RoundedRectangleBorder(
      //   borderRadius: borderRadius,
      //   side: BorderSide(
      //     color: borderColor ?? Colors.transparent,
      //     width: borderWidth,
      //   ),
      // ),
      child: body,
      // padding: padding,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
    );
    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
