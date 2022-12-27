import 'package:flutter/material.dart';
import 'NSReturnByPlatform.dart';

class NSTouchableHighlight extends StatefulWidget {
  final Widget child;
  final VoidCallback onPress;
  final VoidCallback onLongPress;
  final double width;
  final double height;
  final Color color;
  final Color lightColor;
  final Color darkColor;
  final double cornerRadius;
  final bool togglesOnTouchEnters;
  final NSRenderType renderType;
  final Color selectionColor;

  NSTouchableHighlight({
    @required this.child,
    @required this.onPress,
    this.onLongPress,
    this.width,
    this.height,
    this.color,
    this.lightColor,
    this.darkColor,
    this.cornerRadius = 8,
    this.togglesOnTouchEnters = false,
    this.renderType,
    this.selectionColor,
  });

  @override
  _NSTouchableHighlightState createState() => _NSTouchableHighlightState();
}

class _NSTouchableHighlightState extends State<NSTouchableHighlight> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    final iosPressColor = widget.selectionColor ??
        (MediaQuery.of(context).platformBrightness == Brightness.light
            ? Color(0x55aaaaaa)
            : Color(0x55000000));

    final _color = MediaQuery.of(context).platformBrightness == Brightness.light
        ? widget.lightColor ?? widget.color ?? Colors.transparent
        : widget.darkColor ?? widget.color ?? Colors.transparent;

    final ios = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onPress,
      onLongPress: widget.onLongPress,
      onTapDown: (e) => setState(() => pressed = true),
      onTapCancel: () => setState(() => pressed = false),
      onTapUp: (e) => setState(() => pressed = false),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.cornerRadius),
        child: Container(
          height: widget.height,
          width: widget.width,
          color: _color,
          child: Stack(
            // alignment: Alignment.bottomCenter,
            // overflow: Overflow.visible,
            // fit: StackFit.expand,
            children: <Widget>[
              Center(child: widget.child),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  duration: Duration(milliseconds: 50),
                  child: Container(
                    color: pressed ? iosPressColor : Color(0x0),
                  ),
                  opacity: pressed ? 1 : 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final android = ClipRRect(
      borderRadius: BorderRadius.circular(widget.cornerRadius),
      child: Container(
        height: widget.height,
        width: widget.width,
        child: Material(
          color: _color,
          child: InkWell(
            splashColor: widget.selectionColor,
            borderRadius: BorderRadius.circular(widget.cornerRadius),
            child: widget.child,
            onLongPress: widget.onLongPress,
            onTap: widget.onPress,
          ),
        ),
      ),
    );

    return NSReturnByPlatform(context,
        ios: ios, android: android, renderType: widget.renderType);
  }
}
