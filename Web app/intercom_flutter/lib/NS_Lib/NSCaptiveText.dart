import 'package:flutter/material.dart';
import 'NSLib.dart';
// import 'NSReturnByPlatform.dart';

// class NScaptiveTextNavBar extends StatelessWidget {
//   final String text;
//   final Color lightColor;
//   final Color darkColor;
//   final Color color;
//   final TextStyle style;
//   final String fontFamily;
//   final bool ignoreColorsIfNull;

//   final TextDirection textDirection;
//   final TextAlign textAlign;
//   final FontWeight weight;
//   final double size;

// ignore: non_constant_identifier_names
Widget NScaptiveTextNavBar(
  /*this.*/ String text, {
  /*this.*/ Color color,
  /*this.*/ double size,
  /*this.*/ FontWeight weight,
  /*this.*/ Color lightColor,
  /*this.*/ Color darkColor,
  /*this.*/ TextDirection textDirection,
  /*this.*/ TextAlign textAlign = TextAlign.center,
  /*this.*/ TextStyle style,
  /*this.*/ bool ignoreColorsIfNull = true,
  /*this.*/ String fontFamily,
}) {
  return NSText(
    text,
    size: size,
    textAlign: textAlign,
    textDirection: textDirection,
    weight: FontWeight.bold,
    lightColor: lightColor ?? NSAppBar.kiOSLightItemsColor,
    darkColor: darkColor ?? NSAppBar.kiOSDarkItemsColor,
    color: color ?? NSAppBar.kiOSItemsColor,
    ignoreColorsIfNull: ignoreColorsIfNull,
    ignoreMaterial: true,
    fontFamily: fontFamily,
    overflow: TextOverflow.ellipsis,
    maxLines: 1,
  );
}
// }

// ignore: non_constant_identifier_names
Widget NSCaptiveTextAlertTitle(String text,
    {double fontSize = 15,
    TextAlign align = TextAlign.center,
    TextDirection direction}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: NSText(
      text,
      ignoreMaterial: true,
      ignoreColorsIfNull: true,
      // style: TextStyle(
      size: fontSize,
      fontFamily: NSAlertButton.font ?? NSText.globalFontFamily,
      weight: FontWeight.bold,
      // ),
      textAlign: align,
      textDirection: direction,
    ),
  );
}

// ignore: non_constant_identifier_names
Widget NScaptiveTextActionSheetAlertTitle(String text,
    {double fontSize = 15, Color color}) {
  return NSText(
    text,
    ignoreMaterial: true,
    ignoreColorsIfNull: true,
    // style: TextStyle(
    fontFamily: NSAlertButton.font ?? NSText.globalFontFamily,
    size: fontSize,
    color: color ??
        NSColor.platform(
            android: NSColor.fromColor(
                light: Colors.grey[700], dark: Colors.grey[700])),
    weight: FontWeight.bold,
    // ),
  );
}

// ignore: non_constant_identifier_names
Widget NScaptiveTextActionSheetAlertMessage(String text,
    {double fontSize = 15}) {
  return NSText(
    text,
    ignoreMaterial: true,
    ignoreColorsIfNull: true,
    // style: TextStyle(
    size: fontSize,
    fontFamily: NSAlertButton.font ?? NSText.globalFontFamily,
    color: NSColor.platform(
        android: NSColor.fromColor(light: Colors.grey, dark: Colors.grey)),
    // fontWeight: FontWeight.bold,
    // ),
  );
}

class NSText extends StatelessWidget {
  static String globalFontFamily;
  final String fontFamily;
  final String text;
  final Color lightColor;
  final Color darkColor;
  final Color color;
  final TextDirection textDirection;
  final TextAlign textAlign;
  // final TextStyle style;
  final FontWeight weight;
  final double size;
  final bool selectable;
  final bool ignoreColorsIfNull;
  final bool ignoreMaterial;
  final TextOverflow overflow;
  final int maxLines;
  final double textScaleFactor;
  NSText(
    this.text, {
    this.color,
    this.size,
    this.weight,
    this.lightColor,
    this.darkColor,
    this.textDirection,
    this.textAlign = TextAlign.center,
    // this.style = const TextStyle(),
    this.selectable = false,
    this.ignoreColorsIfNull = false,
    this.ignoreMaterial = false,
    this.fontFamily,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
  });

  NSText.localized(
    String text, {
    this.color,
    this.size,
    this.weight,
    this.lightColor,
    this.darkColor,
    this.textDirection,
    this.textAlign = TextAlign.center,
    // this.style = const TextStyle(),
    this.selectable = false,
    this.ignoreColorsIfNull = false,
    this.ignoreMaterial = false,
    this.fontFamily,
    this.overflow,
    this.maxLines,
    this.textScaleFactor,
  }) : this.text = NSLocalizer.translate(text);

  @override
  Widget build(BuildContext context) {
    final _fontFamily = fontFamily ?? globalFontFamily;
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? color ?? lightColor ?? (ignoreColorsIfNull ? null : Colors.black)
        : color ?? darkColor ?? (ignoreColorsIfNull ? null : Colors.white);

    final sstyle = TextStyle().copyWith(
      fontSize: size,
      fontWeight: weight,
      fontFamily: _fontFamily,
      color: _color,
    );

    final theWidget = selectable
        ? SelectableText(
            text,
            maxLines: maxLines,
            style: sstyle,
            textAlign: textAlign,
            textDirection: textDirection,
          )
        : Text(
            text,
            textScaleFactor: textScaleFactor,
            maxLines: maxLines,
            overflow: overflow,
            style: sstyle,
            textAlign: textAlign,
            textDirection: textDirection,
          );

    return theWidget;
    // return NSReturnByPlatform(
    //   context,
    //   ios: theWidget,
    //   android: ignoreMaterial
    //       ? theWidget
    //       : Material(type: MaterialType.transparency, child: theWidget),
    // );
  }
}
