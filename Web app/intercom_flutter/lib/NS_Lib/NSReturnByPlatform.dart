// import 'package:flutter/foundation.dart';
import 'dart:io';

import 'package:flutter/material.dart';

enum NSRenderType { iOS, android, auto }

NSRenderType kRenderType;

// ignore: non_constant_identifier_names
T NSReturnByPlatform<T>(BuildContext context,
    {T ios, T android, NSRenderType renderType}) {
  switch (renderType ?? kRenderType) {
    case NSRenderType.iOS:
      return ios;

    case NSRenderType.android:
      return android;

    case NSRenderType.auto:
    default:
      try {
        if (Platform.isIOS || Platform.isMacOS) {
          return ios;
        } else {
          return android;
        }
      } catch (err) {
        return ios;
      }
  }
}
