import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NSAlertbutton.dart';
import 'NSReturnByPlatform.dart';

enum AlertStyle { alert, actionSheet }

class NSAlert extends StatelessWidget {
  final Widget title;
  final Widget message;
  final List<Widget> actions;
  final String dismissTitle;
  final AlertStyle style;
  static String fontFamily = 'SF Pro Text';
  NSAlert(
      {this.title,
      this.message,
      this.actions,
      this.dismissTitle = 'Dismiss',
      this.style = AlertStyle.alert});

  @override
  Widget build(BuildContext context) {
    Widget dismiss = dismissTitle != null
        ? NSAlertButton.titled(dismissTitle,
            isDefaultAction: true, onPressed: () {})
        : null;

    List<Widget> _actions =
        (actions ?? <Widget>[]) + (dismiss != null ? [dismiss] : []);
    StatelessWidget ios;
    StatelessWidget android;

    if (style == AlertStyle.actionSheet) {
      ios = CupertinoActionSheet(
        title: title,
        message: message,
        actions: actions,
        cancelButton: dismiss,
      );
    } else {
      ios = CupertinoAlertDialog(
        title: title,
        content: message,
        actions: _actions,
      );
    }

    if (style == AlertStyle.actionSheet) {
      android = SimpleDialog(
        title: title,
        children: _actions,
      );
    } else {
      android = AlertDialog(
        title: title,
        content: message,
        actions: _actions,
      );
    }
    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
