import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'NSReturnByPlatform.dart';

class NSListItem extends StatefulWidget {
  final Widget title;
  final Widget leading;
  final Widget trailing;
  final Widget subtitle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Color backgroundColor;
  NSListItem(
      {Key key,
      this.backgroundColor,
      this.title,
      this.leading,
      this.trailing,
      this.subtitle,
      this.onTap,
      this.onLongPress});
  @override
  State<StatefulWidget> createState() => _NSListItemState();
}

class _NSListItemState extends State<NSListItem> {
  bool pressed = false;

  Widget _tapGestureRecogniser(Widget child) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (e) {
        setState(() {
          pressed = true;
        });
      },
      onTapCancel: () {
        setState(() {
          pressed = false;
        });
      },
      onTapUp: (e) {
        setState(() {
          pressed = false;
        });
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsets.fromLTRB(8, 16, 8, 16);
    final iOSSelectedColor =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.grey[300]
            : Colors.grey[900];
    Widget ios = _tapGestureRecogniser(
      Container(
        color: pressed ? iOSSelectedColor : widget.backgroundColor,
        child: Row(
          children: <Widget>[
            Padding(
              padding: padding,
              child: widget.leading ?? SizedBox.shrink(),
            ),
            Expanded(
              child: Padding(
                padding: padding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    widget.title ?? SizedBox.shrink(),
                    widget.subtitle ?? SizedBox.shrink(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: padding,
              child: widget.trailing ?? SizedBox.shrink(),
            )
          ],
        ),
      ),
    );

    Widget android = Container(
      color: widget.backgroundColor,
      child: ListTile(
        title: widget.title,
        leading: widget.leading,
        subtitle: widget.subtitle,
        trailing: widget.trailing,
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
      ),
    );
    return NSReturnByPlatform(context, ios: ios, android: android);
  }
}
