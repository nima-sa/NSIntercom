import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'NSCaptiveText.dart';
import 'NSReturnByPlatform.dart';

class NSTabController extends TabController {
  final int length;
  final TickerProvider vsync;
  final int initialIndex;

  _NSTabBarState state;

  NSTabController({this.length, this.vsync, this.initialIndex})
      : super(length: length, vsync: vsync, initialIndex: initialIndex);

  @override
  void animateTo(int value,
      {Duration duration = kTabScrollDuration, Curve curve = Curves.ease}) {
    super.animateTo(value, duration: duration, curve: curve);
    state.changeTab(value);
  }
}

class NSTabBar extends StatefulWidget {
  final List<NSTabBarItem> tabs;
  final NSTabController controller;
  final NSRenderType renderType;
  final Function(int value) onChange;

  final Color androidSelectedColorLight;
  final Color androidSelectedColorDark;
  final Color androidSelectedColor;

  const NSTabBar({
    Key key,
    @required this.tabs,
    @required this.controller,
    this.renderType,
    this.onChange,
    this.androidSelectedColorLight,
    this.androidSelectedColorDark,
    this.androidSelectedColor,
  }) : super(key: key);
  @override
  _NSTabBarState createState() => _NSTabBarState();
}

class _NSTabBarState extends State<NSTabBar> {
  int gv = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.state = this;
  }

  @override
  Widget build(BuildContext context) {
    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? widget.androidSelectedColor ?? widget.androidSelectedColorLight
        : widget.androidSelectedColor ?? widget.androidSelectedColorDark;

    final android = TabBar(
      indicatorColor: _color,
      onTap: changeTab,
      tabs: widget.tabs,
      controller: widget.controller,
    );

    Map<int, NSTabBarItem> _tabs = {};
    int i = 0;

    for (NSTabBarItem w in widget.tabs) {
      w.itemIndex ??= i;
      _tabs[i++] = w;
    }

    final ios = CupertinoSlidingSegmentedControl(
      groupValue: gv,
      children: _tabs,
      onValueChanged: changeTab,
    );

    return NSReturnByPlatform(
      context,
      ios: ios,
      android: android,
      renderType: widget.renderType,
    );
  }

  void changeTab(int value) {
    if (value == gv) return;
    bool isiOS = NSReturnByPlatform(
      context,
      ios: true,
      android: false,
      renderType: widget.renderType,
    );
    widget.controller.index = value;
    gv = value;
    if (isiOS) this.setState(() => null);
    if (widget.onChange != null) widget.onChange(value);
  }
}

// ignore: must_be_immutable
class NSTabBarItem extends StatelessWidget {
  final Widget widget;
  final TabController controller;
  int itemIndex;
  final String fontFamily;
  final double fontSize;
  final FontWeight weight;
  final IconData icon;
  final String text;
  final int type;
  final Color selectedColor;
  final Color deselectedColor;

  NSTabBarItem.icon(
    this.icon, {
    @required this.controller,
    this.selectedColor,
    this.deselectedColor,
    this.itemIndex,
  })  : widget = null,
        text = '',
        type = 0,
        fontFamily = null,
        fontSize = null,
        weight = null;

  NSTabBarItem.text(
    this.text, {
    @required this.controller,
    this.selectedColor,
    this.deselectedColor,
    this.itemIndex,
    this.fontFamily,
    this.fontSize,
    this.weight,
  })  : widget = null,
        icon = null,
        type = 1;

  NSTabBarItem.other(
    this.widget, {
    @required this.controller,
    this.itemIndex,
  })  : fontFamily = null,
        fontSize = null,
        weight = null,
        icon = null,
        text = null,
        type = null,
        selectedColor = null,
        deselectedColor = null;

  @override
  Widget build(BuildContext context) {
    if (type == 0) {
      return Icon(
        icon,
        color: controller.index == itemIndex ? selectedColor : deselectedColor,
      );
    } else if (type == 1) {
      return NSText(text,
          fontFamily: fontFamily,
          weight: weight,
          size: fontSize,
          ignoreColorsIfNull: true,
          ignoreMaterial: true,
          color:
              controller.index == itemIndex ? selectedColor : deselectedColor);
    } else {
      return widget;
    }
  }
}
