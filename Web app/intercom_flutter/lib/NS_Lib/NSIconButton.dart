import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'NSLib.dart';

import 'NSReturnByPlatform.dart';

class NSIconButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final Color backgroundColor;
  final Color disabledColor;
  final num pressedOpacity;
  final Color iconColor;
  final Color lightIconColor;
  final Color darkIconColor;
  final BorderRadius borderRadius;
  final EdgeInsets androidPadding;
  final EdgeInsets padding;
  final double iconSize;
  NSIconButton({
    Key key,
    @required this.icon,
    this.padding = const EdgeInsets.all(8),
    this.backgroundColor,
    this.iconColor, // = Colors.black,
    this.lightIconColor,
    this.darkIconColor,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    @required this.onPressed,
    this.onLongPress,
    this.androidPadding,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? lightIconColor ?? iconColor
        : darkIconColor ?? iconColor;

    Widget ios;
    //  = NSTouchableOpacity(
    //   child: icon,
    //   onPress: onPressed,
    //   onLongPress: onLongPress,
    //   color: _color,
    // );

    // ios = Container(
    //   decoration: BoxDecoration(
    //     borderRadius: BorderRadius.circular(3000),
    //     color: backgroundColor,
    //   ),
    //   // child: ShaderMask(
    //   // shaderCallback: (Rect bounds) {
    //   // return LinearGradient(colors: [_color], stops: [0])
    //   // .createShader(bounds);
    //   // },
    // child: NSButton(
    //     androidPadding: androidPadding,
    //     body: kIsWeb
    //         ? icon
    //         : ShaderMask(
    //             shaderCallback: (Rect bounds) {
    //               return LinearGradient(colors: [_color], stops: [0])
    //                   .createShader(bounds);
    //             },
    //             child: icon),
    //     padding: padding,
    //     // color: iconColor,x
    //     disabledColor: disabledColor,
    //     onPressed: () {
    //       this.onPressed();
    //     },
    //   ),
    //   // ),
    // );

    Widget android = Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3000),
        color: backgroundColor,
        // boxShadow: [
        // BoxShadow(blurRadius: 5, offset: Offset(0, 1), color: Colors.black)
        // ],
      ),
      child: IconButton(
        padding: padding,
        iconSize: iconSize,
        icon: icon,
        color: _color,
        disabledColor: disabledColor,
        onPressed: () {
          this.onPressed();
        },
      ),
    );
    // ios = Material(
    //   child: android,
    //   color: Colors.transparent,
    //   clipBehavior: Clip.hardEdge,
    //   borderRadius: BorderRadius.circular(3000),
    //   borderOnForeground: true,
    // );

    ios = Container(
      padding: padding,
      width: padding.horizontal + iconSize,
      height: padding.vertical + iconSize,

      // color: Colors.red,
      child: NSButton(
        padding: EdgeInsets.zero,
        body: icon,
        color: backgroundColor,
        onPressed: onPressed,
        onLongPress: onLongPress,
      ),
    );

    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
