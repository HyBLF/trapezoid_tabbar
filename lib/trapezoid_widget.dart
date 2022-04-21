import 'package:flutter/material.dart';

/// trapezoid_widget
/// @Auther: huyue
/// @datetime: 2022/4/19
/// @desc: 梯形，由Container变异

/// 梯形斜坡朝向
enum SlopePosition {
  LEFT_TOP,
  LEFT_BOTTOM,
  RIGHT_TOP,
  RIGHT_BOTTOM,
}

class TrapezoidContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final Color color;
  final SlopePosition position;

  const TrapezoidContainer(
      {Key? key,
      this.height = 44,
      this.width = double.infinity,
      this.backgroundColor = Colors.white,
      this.color = Colors.orange,
      this.position = SlopePosition.RIGHT_TOP})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderSide trapezoidSide =
        BorderSide(color: color, width: height, style: BorderStyle.solid);
    BorderSide backSide = BorderSide(
        color: backgroundColor, width: height, style: BorderStyle.solid);

    Border border;
    switch (position) {
      case SlopePosition.LEFT_TOP:
        border = Border(left: backSide, bottom: trapezoidSide);
        break;
      case SlopePosition.LEFT_BOTTOM:
        border = Border(left: backSide, top: trapezoidSide);
        break;
      case SlopePosition.RIGHT_BOTTOM:
        border = Border(right: backSide, top: trapezoidSide);
        break;
      default: // SlopePosition.RIGHT_TOP
        border = Border(right: backSide, bottom: trapezoidSide);
        break;
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(border: border),
    );
  }
}
