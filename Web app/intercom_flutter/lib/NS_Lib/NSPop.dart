import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'NSLib.dart';

class NSPop extends StatefulWidget {
  final Widget child;
  final bool dismissible;
  final bool autoClose;
  final Duration appear;
  final Duration autoCloseAfter;
  const NSPop({
    Key key,
    this.child,
    this.dismissible = false,
    this.autoClose = true,
    this.appear = const Duration(milliseconds: 0),
    this.autoCloseAfter = const Duration(seconds: 2),
  }) : super(key: key);
  @override
  _NSPopState createState() => _NSPopState();

  Future<T> show<T>(BuildContext context) async {
    return Navigator.push(
      context,
      ModalBottomSheetRoute(
        // modalBarrierColor: Colors.transparent,
        expanded: true,
        enableDrag: dismissible,
        isDismissible: dismissible,
        duration: Duration(milliseconds: 0),
        animationCurve: Curves.easeInOut,
        builder: (_) => this,

      ),
    );
  }
}

class _NSPopState extends State<NSPop> {
  bool appeared = false;

  @override
  void initState() {
    super.initState();
    _doStuff();
  }

  @override
  Widget build(BuildContext context) {
    return NSScaffold(
      // color: Colors.transparent,
      backgroundColor: Colors.transparent,
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(),
            Container(
              child: AnimatedOpacity(
                opacity: appeared ? 1 : 0,
                duration: widget.appear,
                child: Center(child: widget.child),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _doStuff() async {
    await Future.delayed(Duration(milliseconds: 1));
    setState(() => appeared = true);

    if (widget.autoClose) {
      await Future.delayed(widget.autoCloseAfter);
      Navigator.pop(context);
    }
  }
}
