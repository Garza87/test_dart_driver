import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SectionWrapper extends StatelessWidget {
  SectionWrapper({
    @required this.width,
    @required this.child,
    this.padding = 15,
    this.height,
    this.background = Colors.white70,
    this.borderThickness = 1,
    this.borderColor,
    this.radius = 0.01,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.topPadding,
  });

  final double width;
  final double padding;
  final Widget child;
  final Color background;
  final Color _borderColorDefault = Colors.blue[100];
  final double borderThickness;
  final double height;
  final Color borderColor;
  final double radius;
  final double topPadding;
  final double leftPadding;
  final double rightPadding;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    if ((height == null) || (height == 0.0)) {
      return SizedBox(
        width: width,
        child: Card(
          color: background,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            side: BorderSide(
              color: (borderColor == null) ? _borderColorDefault : borderColor,
              width: borderThickness,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              (leftPadding != null) ? leftPadding : padding,
              (topPadding != null) ? topPadding : padding,
              (rightPadding != null) ? rightPadding : padding,
              (bottomPadding != null) ? bottomPadding : padding,
            ),
            child: child,
          ),
        ),
      );
    }
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        color: background,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          side: BorderSide(
            color: (borderColor == null) ? _borderColorDefault : borderColor,
            width: borderThickness,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: child,
        ),
      ),
    );
  }
}