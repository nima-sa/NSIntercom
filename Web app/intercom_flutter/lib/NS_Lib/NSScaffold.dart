import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'NSLib.dart';
import 'NSAlert.dart';
import 'NSAppBar.dart';
import 'NSColor.dart';
import 'NSPageRoute.dart';
import 'NSReturnByPlatform.dart';

enum ToastType { other, success, warning, error }

class NSScaffold extends StatefulWidget {
  static Color background;
  static Color lightBackground;
  static Color darkBackground;

  final Widget body;
  final NSAppBar appBar;
  final Widget floatingActionButton;
  final Color backgroundColor;
  final Color lightBackgroundColor;
  final Color darkBackgroundColor;
  final Widget drawer;
  final Widget endDrawer;
  final bool resizeToAvoidBottomInset;

  NSScaffold({
    Key key,
    this.body,
    this.appBar,
    this.floatingActionButton,
    this.backgroundColor,
    this.lightBackgroundColor,
    this.darkBackgroundColor,
    this.drawer,
    this.endDrawer,
    this.resizeToAvoidBottomInset = true,
    // this.iOSDrawerKey,
  }) : super(key: key);
  @override
  NSScaffoldState createState() => NSScaffoldState();

  @Deprecated('Use nsToast.show() method instead.')
  static Future<void> toast(
    BuildContext context,
    Widget content, {
    Widget Function(BuildContext context, ScrollController controller) builder,
    Duration duration = const Duration(seconds: 2),
    Color backgroundColor,
    ToastType type = ToastType.other,
    bool autoClose = true,
    bool dismissible = false,
  }) async {
    showBottomSheetWidget(
      context,
      content,
      vPadding: 26,
      builder: builder,
      dismissible: dismissible,
      color: backgroundColor ??
          (type == ToastType.success
              ? Colors.green
              : type == ToastType.warning
                  ? Colors.amber
                  : type == ToastType.error
                      ? Colors.red
                      : backgroundColor),
    );
    if (autoClose) {
      await Future.delayed(duration);
      Navigator.pop(context);
    }
  }

  static Future<T> pushScreen<T extends Object>(
      BuildContext context, Widget screen,
      {bool fullscreenDialog = false}) async {
    final result = await Navigator.push(
        context,
        NSPageRoute<T>(
            builder: (context) => screen, fullscreenDialog: fullscreenDialog));
    return result;
  }

  static Future<T> showBottomSheetWidget<T>(
    BuildContext context,
    Widget widget, {
    bool dismissible = true,
    Color color,
    double vPadding = 8,
    Widget Function(BuildContext, ScrollController) builder,
  }) async {
    return Navigator.push(
      context,
      ModalBottomSheetRoute(
        expanded: false,
        isDismissible: dismissible,
        duration: Duration(milliseconds: 200),
        animationCurve: Curves.easeIn,
        builder: builder ??
            (_) => Container(
                  child: widget,
                  color: color ?? NSColor(0xFFFFFFFF, 0xFF000000),
                  padding: EdgeInsets.only(
                    top: vPadding,
                    bottom: MediaQuery.of(context).padding.bottom + vPadding,
                  ),
                ),
      ),
    );
  }

  static Future<T> showBottomSheet<T>(
    BuildContext context,
    Widget screen, {
    bool dismissible = true,
    Widget Function(BuildContext context, ScrollController scrollController)
        builder,
    Color backgroundColor,
    bool safeArea = true,
  }) async /*: assert ((screen == null && builder != null) || (screen != null && builder == null)) */ {
    return await Navigator.push(
      context,
      ModalBottomSheetRoute(
        expanded: false,
        isDismissible: dismissible,
        duration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        builder: builder ??
            (_) => IgnorePointer(
                  ignoring: !dismissible,
                  child: SafeArea(
                    bottom: safeArea,
                    top: safeArea,
                    right: safeArea,
                    left: safeArea,
                    child: Container(
                      child: screen,
                      color: backgroundColor ?? NSColor(0xFFFFFFFF, 0xFF000000),
                      // padding: EdgeInsets.only(
                      //   top: 0,
                      //   bottom: MediaQuery.of(context).padding.bottom + 0,
                      // ),
                    ),
                  ),
                ),
      ),
    );
  }

  static Future<T> showActionSheet<T>(BuildContext context,
      {NSAlert Function(BuildContext context) builder,
      NSRenderType renderType}) async {
    // static Future<T> showActionSheet<T>(
    //   BuildContext context, {
    //   Widget title,
    //   Widget message,
    //   List<NSAlertButton> actions,
    //   String dismissTitle = 'Cancel',
    //   AlertStyle style = AlertStyle.alert,
    //   NSRenderType renderType,
    // }) async {

    final alert = builder(context);
    final title = alert.title;
    final actions = alert.actions;
    final dismissTitle = alert.dismissTitle;
    final message = alert.message;

    Function(BuildContext c1) _builder;

    final pf =
        NSReturnByPlatform(context, ios: 1, android: 2, renderType: renderType);
    // iOS Section
    if (pf == 1) {
      final double _sigmaX = 10;
      final double _sigmaY = 10;
      Widget iOSDefaultButton;
      List<Widget> iOSButtons = [];
      double iOSClip = 16;
      if (dismissTitle != null) {
        actions.insert(
            0, NSAlertButton.titled(dismissTitle, isDefaultAction: true));
      }
      for (NSAlertButton button in actions) {
        final double opacity =
            button.isDefaultAction && iOSDefaultButton == null ? 1 : 0.6;

        final _b = BackdropFilter(
          filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
          child: Container(
            color: NSColor.fromRGBO(255, 255, 255, 1, 0, 0, 0, 1)
                .withOpacity(opacity),
            child: button,
          ),
        );

        if (button.isDefaultAction) {
          if (iOSDefaultButton == null) {
            iOSDefaultButton = ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(iOSClip)),
              child: _b,
            );
            continue;
          }
        }
        iOSButtons.add(_b);
      }
      final int _l = iOSButtons.length;
      List<Widget> finlList = [];
      for (int i = 0; i < _l; i++) {
        bool isLast = i == _l - 1;
        bool isFirst = i == 0;
        final _b = iOSButtons.removeAt(0);
        finlList.add(
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(isLast ? iOSClip : 0),
              bottomRight: Radius.circular(isLast ? iOSClip : 0),
              topLeft: Radius.circular(isFirst ? iOSClip : 0),
              topRight: Radius.circular(isFirst ? iOSClip : 0),
            ),
            child: _b,
          ),
        );
        if (!isLast) finlList.add(Divider(height: 0.5));
      }

      _builder = (BuildContext _) => Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 8,
              left: 8,
              right: 8,
              // top: 8,
            ),
            child: ListView(
              // reverse: true,
              padding: EdgeInsets.zero,
              // controller: c2,
              shrinkWrap: true,
              children: (title != null ? [title] : []) +
                  (message != null ? [message] : []) +
                  finlList +
                  (iOSDefaultButton != null
                      ? [
                          SizedBox(height: 10),
                          iOSDefaultButton,
                        ]
                      : []),
            ),
          );
    }
    // android section
    else if (pf == 2) {
      Widget androidDismiss;

      if (dismissTitle != null) {
        androidDismiss = ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: NSAlertButton.titled(dismissTitle, isDefaultAction: true),
        );
      }

      final int _l = actions.length;
      List<Widget> finlList = [];
      for (int i = 0; i < _l; i++) {
        bool isLast = i == _l - 1;
        bool isFirst = i == 0;
        finlList.add(
          Padding(
            padding: EdgeInsets.only(top: isFirst ? 0 : 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: actions[i],
            ),
          ),
        );
        if (!isLast) finlList.add(Divider(height: 0.5));
      }

      _builder = (BuildContext _) => Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: NSColor.fromColor(
                      dark: Colors.grey[900], light: Colors.grey),
                  blurRadius: 0,
                  offset: Offset(0, -1),
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: Material(
                type: MaterialType.canvas,
                child: Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 8,
                    left: 8,
                    right: 8,
                    top: 8,
                  ),
                  child: ListView(
                    // reverse: true,
                    padding: EdgeInsets.zero,
                    // controller: c2,
                    shrinkWrap: true,
                    children: (title != null ? [title] : <Widget>[]) +
                        (message != null ? [message] : <Widget>[]) +
                        (title != null || message != null
                            ? [Divider(height: 0.5)]
                            : <Widget>[]) +
                        finlList +
                        (androidDismiss != null
                            ? [
                                Divider(height: 0.5),
                                androidDismiss,
                              ]
                            : <Widget>[]),
                  ),
                ),
              ),
            ),
          );
    }

    return Navigator.push(
      context,
      ModalBottomSheetRoute(
        expanded: false,
        duration: Duration(milliseconds: 200),
        animationCurve: Curves.easeIn,
        builder: _builder,
      ),
    );
  }

  static Future<T> showAlert<T>(BuildContext context,
      {Widget title,
      Widget message,
      List<Widget> actions,
      String dismissTitle = 'Dismiss',
      AlertStyle style = AlertStyle.alert}) async {
    final alert = NSAlert(
        title: title,
        message: message,
        actions: actions,
        dismissTitle: dismissTitle,
        style: style);

    final actionsheetStyle = NSReturnByPlatform<Function>(context,
        ios: showCupertinoModalPopup, android: showActionSheet);

    final alertStyle = NSReturnByPlatform<Function>(context,
        ios: showCupertinoDialog, android: showDialog);

    if (style == AlertStyle.actionSheet) {
      return actionsheetStyle(context: context, builder: (context) => alert);
    } else {
      return alertStyle(context: context, builder: (context) => alert);
    }
  }

  static Future<T> presentScreen<T extends Object>(
    BuildContext context,
    Widget screen, {
    // bool fullscreen = false,
    Color backgroundColor = Colors.transparent,
    double elevation,
    ShapeBorder shape,
    Clip clipBehavior,
    Color barrierColor,
    bool bounce = false,
    bool expand = true,
    AnimationController secondAnimation,
    Curve animationCurve = Curves.easeIn,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    Duration duration = const Duration(milliseconds: 200),
    Function(BuildContext) builder,
  }) {
    // if (fullscreen) {
    //   return NSScaffold.pushScreen(context, screen,
    //       fullscreenDialog: fullscreen);
    // }

    // final route = NSReturnFromRender<Function>(context,
    //     ios: showCupertinoModalBottomSheet,
    //     android: showMaterialModalBottomSheet,
    //     web: showCupertinoModalBottomSheet,
    //     kDefault: showCupertinoModalBottomSheet);

    return Navigator.push(
      context,
      ModalBottomSheetRoute(
          expanded: expand,
          isDismissible: isDismissible,
          duration: duration,
          animationCurve: animationCurve,
          builder: builder ?? (_) => screen),
    );

    // return route(
    //   context: context,
    //   backgroundColor: backgroundColor,
    //   elevation: elevation,
    //   shape: shape,
    //   clipBehavior: clipBehavior,
    //   barrierColor: barrierColor,
    //   bounce: bounce,
    //   expand: expand,
    //   secondAnimation: secondAnimation,
    //   animationCurve: animationCurve,
    //   useRootNavigator: useRootNavigator,
    //   isDismissible: isDismissible,
    //   enableDrag: enableDrag,
    //   duration: duration,
    //   builder: builder ?? (_, __) => screen,
    // );
  }

  static void pop<T extends Object>(BuildContext context, [T result]) {
    Navigator.pop(context);
  }
}

class NSScaffoldState extends State<NSScaffold> {
  GlobalKey<NSDrawerState> iOSKey = GlobalKey<NSDrawerState>();
  GlobalKey<ScaffoldState> androidKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final EdgeInsets safeAreaPadding = MediaQuery.of(context).padding;
    Widget iosBody = widget.floatingActionButton != null
        ? Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Expanded(child:
              widget.body,
              // ),
              Positioned(
                child: widget.floatingActionButton,
                bottom: 16,
                right: 16,
              )
            ],
          )
        : widget.body;

final dynColor = MediaQuery.of(context).platformBrightness == Brightness.light
                ? (widget.lightBackgroundColor ?? NSScaffold.lightBackground)
                : (widget.darkBackgroundColor ?? NSScaffold.darkBackground);

    final Color _color = widget.backgroundColor ??
        NSScaffold.background;

    Widget ios;
    StatefulWidget iosScaffold = CupertinoPageScaffold(
      backgroundColor: _color ?? dynColor,
      child: iosBody,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      navigationBar:
          widget.appBar != null ? widget.appBar.forIOS(context) : null,
    );

    if (widget.drawer != null || widget.endDrawer != null) {
      ios = NSDrawer(
        onTapClose: true,
        key: iOSKey,
        scaffold: iosScaffold,
        leftChild: widget.drawer,
        rightChild: widget.endDrawer,
      );
    } else {
      ios = iosScaffold;
    }

    StatefulWidget android = Scaffold(
      key: androidKey,
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      backgroundColor: _color ?? Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.appBar != null ? widget.appBar.forAndroid() : null,
      body: widget.body,
      floatingActionButton: widget.floatingActionButton,
      drawer: widget.drawer,
      endDrawer: widget.endDrawer,
    );

    return NSReturnByPlatform(context, ios: ios, android: android);
  }

  void openDrawer() {
    final _state = NSReturnByPlatform<int>(
      null,
      ios: 1,
      android: 2,
    );

    if (_state == 1) {
      iOSKey.currentState.openLeading();
    } else {
      androidKey.currentState.openDrawer();
    }
  }

  void openEndDrawer() {
    final _state = NSReturnByPlatform<int>(
      null,
      ios: 1,
      android: 2,
    );

    if (_state == 1) {
      iOSKey.currentState.openTrailing();
    } else {
      androidKey.currentState.openEndDrawer();
    }
  }

  void closeDrawer() {
    final _state = NSReturnByPlatform<int>(
      null,
      ios: 1,
      android: 2,
    );

    if (_state == 1) {
      iOSKey.currentState.closeLeading();
    } else {
      if (this.androidKey.currentState.isDrawerOpen) Navigator.pop(context);
    }
  }

  void closeEndDrawer() {
    final _state = NSReturnByPlatform<int>(
      null,
      ios: 1,
      android: 2,
    );

    if (_state == 1) {
      iOSKey.currentState.closeTrailing();
    } else {
      if (this.androidKey.currentState.isEndDrawerOpen) Navigator.pop(context);
    }
  }
}
