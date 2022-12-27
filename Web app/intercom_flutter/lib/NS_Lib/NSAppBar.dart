import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NSLib.dart';

class NSAppBar {
  static Color color;
  static Color kiOSItemsColor;
  static Color kiOSLightItemsColor;
  static Color kiOSDarkItemsColor;

  final Widget title;
  final List<Widget> leadingButtons;
  final List<Widget> trailingButtons;
  final String backButtonTitle;
  final Color iOSItemsColor;
  final Color iOSLightItemsColor;
  final Color iOSDarkItemsColor;

  final Color backgroundColor;

  final Key key;
  final double androidElevation;
  final bool androidCentersTitle;
  NSAppBar({
    this.key,
    this.title,
    this.leadingButtons,
    this.trailingButtons,
    this.iOSItemsColor,
    this.backButtonTitle,
    this.backgroundColor,
    this.iOSLightItemsColor,
    this.iOSDarkItemsColor,
    this.androidElevation,
    this.androidCentersTitle = true,
  });

  NSAppBar.withTitle(
    String _title, {
    this.key,
    this.leadingButtons,
    this.trailingButtons,
    this.iOSItemsColor,
    this.backButtonTitle,
    this.backgroundColor,
    this.iOSLightItemsColor,
    this.iOSDarkItemsColor,
    this.androidElevation,
    this.androidCentersTitle = true,
  }) : title = NScaptiveTextNavBar(_title);

  CupertinoNavigationBar forIOS(BuildContext context) {
    // final _color = MediaQuery.of(context).platformBrightness == Brightness.light
    //     ? iOSLightItemsColor ??
    //         iOSItemsColor ??
    //         NSAppBar.kiOSLightItemsColor ??
    //         NSAppBar.kiOSItemsColor
    //     : iOSDarkItemsColor ??
    //         iOSItemsColor ??
    //         NSAppBar.kiOSDarkItemsColor ??
    //         NSAppBar.kiOSItemsColor;
    return CupertinoNavigationBar(
      key: key,
      backgroundColor: backgroundColor ?? color,
      middle: title,
      // actionsForegroundColor: _color ?? Colors.blue,
      leading: leadingButtons != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: leadingButtons,
            )
          : null,
      trailing: trailingButtons != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: trailingButtons,
            )
          : null,
      previousPageTitle: backButtonTitle,
    );
  }

  AppBar forAndroid() {
    final leading = leadingButtons != null && leadingButtons.length > 0
        ? leadingButtons[0]
        : null;
    final List<Widget> etc = leadingButtons != null && leadingButtons.length > 1
        ? leadingButtons.sublist(1)
        : [];
    final List<Widget> actions =
        etc + (trailingButtons != null ? trailingButtons : []);

    return AppBar(
      key: key,
      elevation: androidElevation,
      backgroundColor: backgroundColor ?? color,
      title: title,
      leading: leading,
      actions: actions,
      centerTitle: androidCentersTitle,
    );
  }
}
