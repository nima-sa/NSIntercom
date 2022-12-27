import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'NSLib.dart';

import 'NSReturnByPlatform.dart';

class NSAlertButton extends StatelessWidget {
  static String font;

  final Widget child;
  // final bool enabled;
  final bool isDefaultAction;
  final bool isDestructiveAction;
  final VoidCallback onPressed;
  final VoidCallback onLongPress;
  final Color androidLightColor;
  final Color androidDarkColor;
  final Color androidColor;
  final Color toastColor;
  final String title;
  final FontWeight weight;
  final double androidBorderRadius;
  NSAlertButton({
    Widget child,
    // this.enabled,
    this.isDefaultAction = true,
    this.isDestructiveAction = false,
    this.onPressed,
    this.onLongPress,
    this.androidLightColor,
    this.androidDarkColor,
    this.androidColor,
    this.toastColor,
    this.androidBorderRadius,
  })  : this.child =
            Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 4), child: child),
        title = null,
        weight = null;
  NSAlertButton.titled(
    this.title, {
    // this.enabled,
    this.isDefaultAction = false,
    this.isDestructiveAction = false,
    this.onPressed,
    this.onLongPress,
    this.androidLightColor,
    this.androidDarkColor,
    this.androidColor,
    Color textColor,
    this.toastColor,
    this.weight,
    String font,
    this.androidBorderRadius,
  }) : child = Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: NSText(
            title,
            // size: 17,
            ignoreColorsIfNull: true,
            ignoreMaterial: true,
            fontFamily: font ?? NSAlertButton.font, //'SF Pro Text',
            weight: weight ??
                (isDefaultAction ? FontWeight.bold : FontWeight.normal),
            color: textColor ??
                (isDestructiveAction
                    ? Colors.red
                    : NSColor.platform(
                        iOS: NSMaterializedColors.iOSBlue, android: textColor)),
          ),
        );

  NSAlertButton.icon(
    IconData _icon, {
    // this.enabled,
    this.isDefaultAction = true,
    this.isDestructiveAction = false,
    this.onPressed,
    this.onLongPress,
    this.androidLightColor,
    this.androidDarkColor,
    this.androidColor,
    this.toastColor,
    this.androidBorderRadius,
  })  : child = Padding(
            padding: EdgeInsets.all(8), child: Center(child: Icon(_icon))),
        title = null,
        weight = null;

  NSAlertButton.other(
    Widget _title, {
    // this.enabled,
    this.isDefaultAction = true,
    this.isDestructiveAction = false,
    this.onPressed,
    this.onLongPress,
    this.androidLightColor,
    this.androidDarkColor,
    this.androidColor,
    this.toastColor,
    this.androidBorderRadius,
  })  : child = Center(child: _title),
        title = null,
        weight = null;

  NSAlertButton.toast({
    @required this.title,
    Color color,
    this.onPressed,
    this.weight,
    this.isDefaultAction = false,
  })  : toastColor = color ?? NSMaterializedColors.iOSBlue,
        child = null,
        isDestructiveAction = false,
        onLongPress = null,
        androidLightColor = null,
        androidDarkColor = null,
        androidColor = null,
        this.androidBorderRadius = null;

  @override
  Widget build(BuildContext context) {
    final Color _color =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? (androidLightColor ?? androidColor)
            : (androidDarkColor ?? androidColor);
    StatelessWidget ios = CupertinoDialogAction(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: child,
      ),
      isDefaultAction: isDefaultAction,
      isDestructiveAction: isDestructiveAction,
      onPressed: () {
        Navigator.pop(context);
        if (this.onPressed != null) this.onPressed();
      },
    );

    Widget android = TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _color,
        shape: androidBorderRadius != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(androidBorderRadius),
              )
            : null,
      ),
      // shape: androidBorderRadius != null
      //     ? RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(androidBorderRadius),
      //       )
      //     : null,
      // color: _color,
      child: child,
      onPressed: () {
        Navigator.pop(context);
        if (this.onPressed != null) this.onPressed();
      },
      onLongPress: onLongPress,
    );
    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
