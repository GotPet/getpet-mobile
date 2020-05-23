import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// https: //stackoverflow.com/questions/58352828/flutter-design-instagram-like-balloons-tooltip-widget
class TooltipShapeBorder extends ShapeBorder {
  final double arrowWidth;
  final double arrowHeight;
  final double arrowArc;
  final double radius;

  TooltipShapeBorder({
    this.radius = 16.0,
    this.arrowWidth = 20.0,
    this.arrowHeight = 10.0,
    this.arrowArc = 0.0,
  }) : assert(arrowArc <= 1.0 && arrowArc >= 0.0);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.only(bottom: arrowHeight);

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) => null;

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    rect = Rect.fromPoints(
        rect.topLeft, rect.bottomRight - Offset(0, arrowHeight));
    double x = arrowWidth, y = arrowHeight, r = 1 - arrowArc;
    return Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)))
      ..moveTo(rect.bottomCenter.dx + x / 2, rect.bottomCenter.dy)
      ..relativeLineTo(-x / 2 * r, y * r)
      ..relativeQuadraticBezierTo(
          -x / 2 * (1 - r), y * (1 - r), -x * (1 - r), 0)
      ..relativeLineTo(-x / 2 * r, -y * r);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}

// https: //stackoverflow.com/questions/58352828/flutter-design-instagram-like-balloons-tooltip-widget
class TooltipWithArrow extends StatelessWidget {
  final String message;
  final Widget child;
  final Key tooltipKey;

  const TooltipWithArrow({
    Key key,
    @required this.message,
    @required this.child,
    this.tooltipKey,
  })  : assert(message != null),
        assert(child != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      decoration: ShapeDecoration(
        color: Colors.red,
        shape: TooltipShapeBorder(arrowArc: 0.5),
        shadows: [
          BoxShadow(
              color: Colors.black26, blurRadius: 4.0, offset: Offset(2, 2))
        ],
      ),
      key: tooltipKey,
      padding: EdgeInsets.all(16),
      textStyle: TextStyle(color: Colors.white),
      message: message,
      child: child,
    );
  }
}
