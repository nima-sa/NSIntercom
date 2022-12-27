import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSApp extends StatelessWidget {
  static final defaultLightTheme = ThemeData(
      primaryColor: Colors.white,
      primaryColorBrightness: Brightness.light,
      brightness: Brightness.light,
      primaryColorDark: Colors.black,
      canvasColor: Colors.white,
      appBarTheme: AppBarTheme(brightness: Brightness.light));

  static final defaultDarkTheme = ThemeData(
      primaryColor: Colors.black,
      primaryColorBrightness: Brightness.dark,
      primaryColorLight: Colors.black,
      brightness: Brightness.dark,
      primaryColorDark: Colors.black,
      indicatorColor: Colors.white,
      canvasColor: Colors.black,
      // next line is important!
      appBarTheme: AppBarTheme(brightness: Brightness.dark));

  final Widget home;
  final String title;
  final ThemeData theme;
  final ThemeData darkTheme;
  final bool debugShowCheckedModeBanner;
  final Map<String, Widget Function(BuildContext)> routes;
  final Route<dynamic> Function(RouteSettings) onGenerateRoute;

  NSApp({
    Key key,
    this.home,
    this.title,
    this.debugShowCheckedModeBanner = false,
    this.theme,
    this.darkTheme,
    this.routes = const {},
    this.onGenerateRoute,
  });

  @override
  Widget build(BuildContext context) {
    StatefulWidget android = MaterialApp(
      title: title,
      home: home,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      theme: theme,
      routes: routes,
      darkTheme: darkTheme,
      onGenerateRoute: onGenerateRoute,
    );

    StatefulWidget ios = CupertinoApp(
      home: home,
      title: title,
      routes: routes,
      theme: CupertinoThemeData(primaryColor: theme.primaryColor),
      onGenerateRoute: onGenerateRoute,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      localizationsDelegates: [
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );

    return NSReturnByPlatform(context, ios: ios, android: android);

    // try {
    //   if (Platform.isIOS || Platform.isMacOS || kIsWeb) {
    //     return ios;
    //   } else {
    //     return defaultRender;
    //   }
    // } catch (err) {
    //   return kIsWeb ? ios : defaultRender;
    // }
  }
}
