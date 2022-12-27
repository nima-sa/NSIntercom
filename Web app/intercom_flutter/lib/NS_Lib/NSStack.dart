import 'package:flutter/material.dart';

enum NSStackDirection { vertical, horizontal, stacked }

// enum _ForMode { width, height }

// class NSStackResponsiveBehaviour {
//   double threshold;
//   NSStackDirection before, after;

//   final _ForMode mode;

//   NSStackResponsiveBehaviour.forWidth(
//       {@required this.threshold, @required before, @required after})
//       : this.mode = _ForMode.width;

//   NSStackResponsiveBehaviour.forHeight(
//       {@required this.threshold, @required before, @required after})
//       : this.mode = _ForMode.height;
// }

class NSStack extends StatelessWidget {
  final NSStackDirection direction;
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final StackFit fit;

  NSStack({
    this.direction = NSStackDirection.vertical,
    @required this.children,
    this.mainAxisAlignment,
    this.mainAxisSize,
    this.fit,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    switch (this.direction) {
      case NSStackDirection.vertical:
        return Column(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
        );
      case NSStackDirection.horizontal:
        return Row(
          children: children,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: mainAxisSize,
          crossAxisAlignment: crossAxisAlignment,
        );
      case NSStackDirection.stacked:
        return Stack(
          children: children,
          fit: fit,
        );
    }
    return Container();
  }

  static Widget responsive({
    @required double threshold,
    @required NSStackDirection before,
    @required NSStackDirection after,
    @required double currentValue,
    @required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    StackFit fit,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisAlignment beforeMainAxisAlignment,
    CrossAxisAlignment beforeCrossAxisAlignment,
    MainAxisAlignment afterMainAxisAlignment,
    CrossAxisAlignment afterCrossAxisAlignment,
  }) {
    return NSStack(
      direction: currentValue < threshold ? before : after,
      mainAxisSize: mainAxisSize,
      fit: fit,
      mainAxisAlignment: (currentValue < threshold
              ? beforeMainAxisAlignment
              : afterMainAxisAlignment) ??
          mainAxisAlignment,
      crossAxisAlignment: (currentValue < threshold
              ? beforeCrossAxisAlignment
              : afterCrossAxisAlignment) ??
          crossAxisAlignment,
      children: children,
    );
  }
}
