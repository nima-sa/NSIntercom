import 'package:flutter/material.dart';

class NSState<T extends StatefulWidget> extends State<T> {
  @protected
  bool isInitiated = false;

  void once(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    if (!this.isInitiated) {
      this.once(context);
      this.isInitiated = true;
    }
    return null;
  }
}
