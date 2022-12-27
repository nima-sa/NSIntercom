import 'NSLib.dart';
import 'package:flutter/material.dart';

Map<int, Color> _swatchMaker(int r, int g, int b) {
  final Map<int, Color> _map = {
    50: Color.fromRGBO(r, g, b, 0.1),
    100: Color.fromRGBO(r, g, b, 0.2),
    200: Color.fromRGBO(r, g, b, 0.3),
    300: Color.fromRGBO(r, g, b, 0.4),
    400: Color.fromRGBO(r, g, b, 0.5),
    500: Color.fromRGBO(r, g, b, 0.6),
    600: Color.fromRGBO(r, g, b, 0.7),
    700: Color.fromRGBO(r, g, b, 0.8),
    800: Color.fromRGBO(r, g, b, 0.9),
    900: Color.fromRGBO(r, g, b, 1.0),
  };
  return _map;
}

class NSMaterializedColors extends MaterialColor {
  NSMaterializedColors(int r, int g, int b)
      : super(Color.fromRGBO(r, g, b, 1).value, _swatchMaker(r, g, b));

  static Color hexToColor(String code) {
    final String sub = code.substring(4);
    final i = int.parse(sub, radix: 16);
    return Color(i + 0xFF000000);
  }

  static MaterialColor ihex(int h) {
    final color = Color(h);

    final r = color.red;
    final g = color.green;
    final b = color.blue;

    return MaterialColor(color.withAlpha(255).value, _swatchMaker(r, g, b));
  }

  static MaterialColor hex(String h) {
    final color = hexToColor(h);
    final r = color.red;
    final g = color.green;
    final b = color.blue;
    return MaterialColor(color.withAlpha(1).value, _swatchMaker(r, g, b));
  }

  static MaterialColor get black {
    final k = 0;
    return MaterialColor(0xFF000000, _swatchMaker(k, k, k));
  }

  static MaterialColor get white {
    final int k = 220;

    return MaterialColor(0xFFDDDDDD, _swatchMaker(k, k, k));
  }

  static get iOSBlue => NSMaterializedColors(25, 120, 246);
  static get iOSAppBarDark => NSMaterializedColors(27, 27, 27);
  static get iOSAppBar => NSAppearence.returnByAppearence(
        NSMaterializedColors(249, 249, 249),
        NSMaterializedColors(27, 27, 27),
      );
}
