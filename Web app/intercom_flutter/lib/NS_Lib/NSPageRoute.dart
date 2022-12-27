import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// ignore: non_constant_identifier_names
PageRoute NSPageRoute<T>(
    {WidgetBuilder builder, bool fullscreenDialog = false}) {
  PageRoute ios = CupertinoPageRoute<T>(
      builder: builder, fullscreenDialog: fullscreenDialog);
  PageRoute defaultRender = MaterialPageRoute<T>(
      builder: builder, fullscreenDialog: fullscreenDialog);

  try {
    if (Platform.isIOS || Platform.isMacOS) {
      return ios;
    } else {
      return defaultRender;
    }
  } catch (err) {
    return kIsWeb ? ios : defaultRender;
  }
}
