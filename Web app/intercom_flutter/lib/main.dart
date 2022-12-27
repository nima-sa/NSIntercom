import 'package:flutter/material.dart';
import 'package:intercom/HomeScreen.dart';
import 'package:intercom/NS_Lib/NSLib.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kRenderType = NSRenderType.android;
  await NSStorage.recall(key: 'devID');
  await NSStorage.recall(key: 'appID');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NSIntercom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
