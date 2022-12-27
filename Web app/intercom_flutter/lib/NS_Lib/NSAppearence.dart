import 'package:flutter/material.dart';

class NSAppearence {
  static Brightness get appearence =>
      MediaQueryData.fromWindow(WidgetsBinding.instance.window)
          .platformBrightness;

  static T returnByAppearence<T>(T light, T dark) {
    return appearence == Brightness.light ? light : dark;
  }

  static T by<T>(T light, T dark) => returnByAppearence(light, dark);
}
