// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:oprema/NS_Lib/NSLib.dart';

// // Every method in this class should be called in a Widget that re-renders when setState is called. Otherwise changes would not apply
// class NSColor extends Color {
//   static int _evalForTheme({@required int light, @required int dark}) {
//     return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
//                 .platformBrightness ==
//             Brightness.light
//         ? light
//         : dark;
//   }

//   NSColor(int light, int dark) : super(_evalForTheme(light: light, dark: dark));

//   NSColor.fromColor({Color light, Color dark})
//       : super(
//           MediaQueryData.fromWindow(WidgetsBinding.instance.window)
//                       .platformBrightness ==
//                   Brightness.light
//               ? light.value
//               : dark.value,
//         );

//   NSColor.fromRGBO(
//       int lr, int lg, int lb, double lo, int dr, int dg, int db, double _do)
//       : super(
//           _evalForTheme(
//               light: Color.fromRGBO(lr, lg, lb, lo).value,
//               dark: Color.fromRGBO(dr, dg, db, _do).value),
//         );

//   NSColor.platform({Color iOS, Color android, NSRenderType force})
//       : super(NSReturnByPlatform(null,
//                 ios: iOS, android: android, renderType: force)
//             .value);
// }

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'NSLib.dart';

// Every method in this class should be called in a Widget that re-renders when setState is called. Otherwise changes would not apply
class NSColor extends Color {
  static int _evalForTheme({@required int light, @required int dark}) {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .platformBrightness ==
            Brightness.light
        ? (light ?? 0x00000000)
        : (dark ?? 0x00000000);
  }

// NSColor(int v):super(v);
  NSColor(int light, int dark) : super(_evalForTheme(light: light, dark: dark));
  // factory NSColor(int light, int dark) {
  //   final v = _evalForTheme(light: light, dark: dark);
  //   return v != null ? Color(v) : null;
  // }

  static Color fromColor({Color light, Color dark}) {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                .platformBrightness ==
            Brightness.light
        ? light
        : dark;
  }

  NSColor.fromRGBO(
      int lr, int lg, int lb, double lo, int dr, int dg, int db, double _do)
      : super(
          _evalForTheme(
              light: Color.fromRGBO(lr, lg, lb, lo).value,
              dark: Color.fromRGBO(dr, dg, db, _do).value),
        );

  static Color platform({Color iOS, Color android, NSRenderType force}) {
    return NSReturnByPlatform(null,
        ios: iOS, android: android, renderType: force);
  }

  static Color get text => NSColor.pro(0xFF000000, 0xFFFFFFFF);

  static Color pro(dynamic light, dynamic dark) {
    final _light = light is int ? Color(light) : light;
    final _dark = dark is int ? Color(dark) : dark;
    final ios =
        CupertinoDynamicColor.withBrightness(color: _light, darkColor: _dark);
    final android = NSAppearence.by(_light, _dark);
    return NSReturnByPlatform(null, ios: ios, android: android);
  }
}
