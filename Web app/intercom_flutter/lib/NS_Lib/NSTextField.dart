import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'NSCaptiveText.dart';
import 'NSReturnByPlatform.dart';

const BorderSide kDefaultRoundedBorderSide = BorderSide(
  color: CupertinoDynamicColor.withBrightness(
    color: Color(0x33000000),
    darkColor: Color(0x33FFFFFF),
  ),
  style: BorderStyle.solid,
  width: 0.0,
);
const BoxDecoration kDefaultRoundedBorderDecoration = BoxDecoration(
  color: CupertinoDynamicColor.withBrightness(
    color: CupertinoColors.white,
    darkColor: CupertinoColors.black,
  ),
  border: Border(
    top: kDefaultRoundedBorderSide,
    bottom: kDefaultRoundedBorderSide,
    left: kDefaultRoundedBorderSide,
    right: kDefaultRoundedBorderSide,
  ),
  borderRadius: BorderRadius.all(Radius.circular(5.0)),
);

const kTransparentUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.transparent),
);

const kWhiteUnderlineInputBorder = UnderlineInputBorder(
  borderSide: BorderSide(color: Colors.white),
);

class NSTextField extends StatelessWidget {
  final Color lightTextColor;
  final Color textColor;
  final Color darkTextColor;

  final Color placeholderLightColor;
  final Color placeholderColor;
  final Color placeholderDarkColor;

  final TextInputAction textInputAction;
  final BoxDecoration iOSDecoration;
  final bool iOSDecorationIsDefaultedIfNull;
  final TextEditingController controller;
  final String placeHolder;
  final TextInputType keyboardType;
  final bool autofocus;
  final TextAlign align;
  final TextDirection direction;
  final InputBorder enabledUnderlineInputBorder;
  final InputBorder focusedUnderlineInputBorder;
  final bool ignoreColorsIfNull;
  final bool ignorePlaceholderColorsIfNull;
  final FocusNode focusNode;
  final Function onEditingComplete;
  final String fontFamily;
  final double fontSize;
  final int maxLines;
  final int minLines;
  final bool expands;
  final NSRenderType renderType;
  final EdgeInsetsGeometry padding;
  final bool androidIsDense;
  final bool obscureText;
  final Widget suffix;
  final Widget prefix;

  NSTextField({
    this.minLines = 1,
    this.expands = false,
    this.maxLines = 1,
    this.controller,
    this.lightTextColor,
    this.textColor,
    this.darkTextColor,
    this.placeHolder,
    this.keyboardType,
    this.align = TextAlign.start,
    this.autofocus = false,
    this.direction,
    this.obscureText = false,
    this.enabledUnderlineInputBorder,
    this.focusedUnderlineInputBorder,
    this.placeholderLightColor,
    this.placeholderColor,
    this.placeholderDarkColor,
    this.ignorePlaceholderColorsIfNull = false,
    this.ignoreColorsIfNull = false,
    this.iOSDecoration = kDefaultRoundedBorderDecoration,
    this.iOSDecorationIsDefaultedIfNull = true,
    this.focusNode,
    this.textInputAction,
    this.onEditingComplete,
    this.fontFamily,
    this.fontSize,
    this.renderType,
    this.padding,
    this.suffix,
    this.prefix,
    this.androidIsDense = false,
  });

  @override
  Widget build(BuildContext context) {
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? textColor ??
            lightTextColor ??
            (ignoreColorsIfNull ? null : Colors.black)
        : textColor ??
            darkTextColor ??
            (ignoreColorsIfNull ? null : Colors.white);

    final _placeholderColor =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? placeholderColor ??
                placeholderLightColor ??
                (ignorePlaceholderColorsIfNull ? null : Colors.grey)
            : placeholderColor ??
                placeholderDarkColor ??
                (ignorePlaceholderColorsIfNull ? null : Colors.grey);

    final ios = CupertinoTextField(
      maxLines: maxLines,
      minLines: minLines,
      obscureText: obscureText,
      padding: padding ?? EdgeInsets.all(6),
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      focusNode: focusNode,
      decoration: iOSDecoration ??
          (iOSDecorationIsDefaultedIfNull
              ? kDefaultRoundedBorderDecoration
              : null),
      suffix: suffix,
      prefix: prefix,
      expands: expands,
      controller: controller,
      placeholder: placeHolder,
      keyboardType: keyboardType,
      autofocus: autofocus,
      textAlign: align,
      placeholderStyle: TextStyle(
        color: _placeholderColor,
        fontSize: fontSize,
      ),
      style: TextStyle(
        fontFamily: fontFamily ?? NSText.globalFontFamily,
        color: _color,
        fontSize: fontSize,
      ),
    );

    final android = TextField(
      expands: expands,
      maxLines: maxLines,
      minLines: minLines,
      obscureText: obscureText,
      onEditingComplete: onEditingComplete,
      textInputAction: textInputAction,
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      autofocus: autofocus,
      textDirection: direction,
      textAlign: align,
      style: TextStyle(
        fontFamily: fontFamily ?? NSText.globalFontFamily,
        color: _color,
        fontSize: fontSize,
      ),
      decoration: InputDecoration(
        hintText: placeHolder,
        suffix: suffix,
        prefix: prefix,
        isDense: androidIsDense,
        contentPadding: padding,
        hintStyle: TextStyle(
          color: _placeholderColor,
          fontFamily: fontFamily ?? NSText.globalFontFamily,
          fontSize: fontSize,
        ),
        enabledBorder: enabledUnderlineInputBorder,
        focusedBorder: focusedUnderlineInputBorder,
      ),
    );
    return NSReturnByPlatform(context,
        ios: ios, android: android, renderType: renderType);
  }
}
