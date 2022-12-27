import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'NSColor.dart';
import 'NSLib.dart';

class NSToast extends StatelessWidget {
  final Widget _widget;
  final Color backgroundColor;
  static Color globalBackgroundColor;
  final ToastType toastType;
  final bool autoClose;
  final bool dismissible;
  final Duration closeDuration;
  final Widget Function(BuildContext context)
      builder;
  // ignore: unused_field
  final int _pType;
  NSToast.text(
    String _title, {
    this.backgroundColor,
    this.toastType = ToastType.other,
    TextDirection textDirection,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = NSText(
          _title,
          textDirection: textDirection ?? NSLocalizer.textDirection,
        ),
        builder = null,
        dismissible = false,
        _pType = 0;

  NSToast.icon(
    IconData _icon, {
    this.backgroundColor,
    this.toastType = ToastType.other,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = Icon(_icon),
        builder = null,
        dismissible = false,
        _pType = 1;

  NSToast.successText(
    String _title, {
    this.backgroundColor = Colors.green,
    Color textColor = Colors.white,
    this.toastType = ToastType.success,
    TextDirection textDirection,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = NSText(
          _title,
          color: textColor,
          weight: FontWeight.bold,
          textDirection: textDirection ?? NSLocalizer.textDirection,
        ),
        builder = null,
        dismissible = false,
        _pType = 2;

  NSToast.warningText(
    String _title, {
    this.backgroundColor = Colors.amber,
    Color textColor = Colors.black,
    this.toastType = ToastType.other,
    TextDirection textDirection,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = NSText(
          _title,
          color: textColor,
          weight: FontWeight.bold,
          textDirection: textDirection ?? NSLocalizer.textDirection,
        ),
        builder = null,
        dismissible = false,
        _pType = 3;

  NSToast.errorText(
    String _title, {
    this.backgroundColor = Colors.red,
    Color textColor = Colors.white,
    this.toastType = ToastType.other,
    TextDirection textDirection,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = NSText(
          _title,
          color: textColor,
          weight: FontWeight.bold,
          textDirection: textDirection ?? NSLocalizer.textDirection,
        ),
        builder = null,
        dismissible = false,
        _pType = 4;

  NSToast.successIcon(
    IconData _icon, {
    this.backgroundColor = Colors.green,
    Color iconColor = Colors.white,
    this.toastType = ToastType.success,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = Icon(_icon, color: iconColor),
        builder = null,
        dismissible = false,
        _pType = 5;

  NSToast.warningIcon(
    IconData _icon, {
    this.backgroundColor = Colors.amber,
    Color iconColor = Colors.black,
    this.toastType = ToastType.success,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = Icon(_icon, color: iconColor),
        builder = null,
        dismissible = false,
        _pType = 6;

  NSToast.errorIcon(
    IconData _icon, {
    this.backgroundColor = Colors.red,
    Color iconColor = Colors.white,
    this.toastType = ToastType.success,
    this.autoClose = true,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = Icon(_icon, color: iconColor),
        builder = null,
        dismissible = false,
        _pType = 7;

  NSToast.other(
    Widget _widget, {
    this.builder,
    this.backgroundColor,
    this.toastType = ToastType.other,
    this.autoClose = true,
    this.dismissible = false,
    this.closeDuration = const Duration(seconds: 2),
  })  : _widget = _widget,
        _pType = 8;

  NSToast.alert({
    Widget title,
    Widget message,
    @required List<NSAlertButton> actions,
    this.backgroundColor,
    this.toastType,
    this.autoClose = false,
    this.dismissible = true,
    String fontFamily,
    this.closeDuration = const Duration(seconds: 2),
    String dismissTitle = 'Cancel',
  })  : _widget = null,
        _pType = 9,
        builder =
            _toastBuilder(title, message, actions, dismissTitle, fontFamily);

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(8), child: _widget);
  }

  Future<void> show(BuildContext context) async {
    Navigator.push(
      context,
      ModalBottomSheetRoute(
        expanded: false,
        isDismissible: dismissible,
        duration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        builder: builder ??
            (_) => Material(
                  color: Colors.transparent,
                  child: IgnorePointer(
                    ignoring: !dismissible,
                    child: Container(
                      child: this,
                      color: backgroundColor ??
                          NSToast.globalBackgroundColor ??
                          NSColor(0xFFFFFFFF, 0xFF000000),
                      padding: EdgeInsets.only(
                        top: 0,
                        bottom: MediaQuery.of(context).padding.bottom + 16,
                      ),
                    ),
                  ),
                ),
      ),
    );
    if (autoClose) {
      await Future.delayed(closeDuration);
      Navigator.pop(context);
    }
  }
}

Widget Function(BuildContext context)
    _toastBuilder(Widget title, Widget message, List<NSAlertButton> actions,
        String dismissTitle, String fontFamily) {
  List<Widget> Function(BuildContext c) childrenBuilder = (context) {
    List<Widget> children = [];
    List<NSAlertButton> _actions = [];
    _actions.addAll(actions);
    children.add(SizedBox(height: 8));

    if (title != null || message != null) {
      if (title != null)
        children.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: title,
          ),
        );
      if (message != null)
        children.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: message,
          ),
        );

      children.add(SizedBox(height: 8));
      children.add(Divider(height: 2));
    }
    if (dismissTitle != null) {
      _actions
          .add(NSAlertButton.toast(title: dismissTitle, isDefaultAction: true));
    }
    if (_actions.length > 0) {
      // int i = -1;
      for (NSAlertButton button in _actions) {
        // i++;
        if (button == null) continue;
        children.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
                0,
                0, //i == _actions.length - 1 && button.isDefaultAction ? 32 : 0,
                0,
                0),
            child: NSTouchableHighlight(
              cornerRadius: 12,
              // renderType: NSRenderType.iOS,
              color: Colors.transparent,
              selectionColor: NSColor.platform(
                iOS: button.toastColor.withAlpha(0x55),
                android: button.toastColor.withAlpha(0xDD),
              ),
              child: Padding(
                // padding: EdgeInsets.all(14),
                padding: EdgeInsets.fromLTRB(
                  14,
                  10, //i == _actions.length - 1 && button.isDefaultAction ? 14 : 14,
                  14,
                  10, //i == _actions.length - 1 && button.isDefaultAction ? 14: 14,
                ),
                child: NSText(
                  button.title,
                  color: button.toastColor,
                  weight: button.weight ??
                      (button.isDefaultAction
                          ? FontWeight.bold
                          : FontWeight.normal),
                  size: 17,
                  fontFamily: fontFamily,
                ),
              ),
              onPress: () {
                NSScaffold.pop(context);
                if (button.onPressed != null) button.onPressed();
              },
            ),
          ),
        );
        children.add(Divider(height: 2));
      }

      children.removeLast();
    }
    return children;
  };

  return (bc) => Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.only(
            // top: 8,
            bottom: MediaQuery.of(bc).padding.bottom + 16,
          ),
          color: NSColor(0xFFFFFFFF, 0xFF000000),
          child: Directionality(
            textDirection: NSLocalizer.textDirection,
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 8),
              // controller: c,
              children: childrenBuilder(bc),
            ),
          ),
        ),
      );
}
