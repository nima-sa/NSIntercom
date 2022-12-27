import 'package:flutter/material.dart';

class NSTouchableBouncer extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve forwardCurve;
  final Curve reverseCurve;
  final double scale;

  NSTouchableBouncer({
    @required this.child,
    this.scale = 0.975,
    // this.scale = 1.05,
    this.duration = const Duration(milliseconds: 500),
    this.forwardCurve = Curves.bounceOut,
    this.reverseCurve = Curves.bounceIn,
  });

  @override
  _NSTouchableBouncerState createState() => _NSTouchableBouncerState();
}

class _NSTouchableBouncerState extends State<NSTouchableBouncer>
    with TickerProviderStateMixin {
  AnimationController _controller;

  void pressDown() {
    _controller.forward();
  }

  void pressUp() {
    _controller.reverse();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (e) => pressDown(),
      onTapUp: (e) => pressUp(),
      onTapCancel: () => pressUp(),
      child: Align(
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: widget.scale).animate(
            CurvedAnimation(
              parent: _controller,
              curve: widget.forwardCurve,
              reverseCurve: widget.reverseCurve,
            ),
          ),
          child: Container(
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
