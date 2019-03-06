import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableFloatingActionButton extends StatefulWidget {
  final double radius;
  final int startAngle;
  final int intervalAngle;
  final Widget mainButton;
  final List<Widget> expandableTwoButton;

  ExpandableFloatingActionButton(
      {this.mainButton,
      this.expandableTwoButton,
      this.radius,
      this.startAngle,
      this.intervalAngle});

  @override
  _ExpandableFloatingActionButtonState createState() =>
      _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState
    extends State<ExpandableFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animationOne;
  Animation<double> animationTwo;
  bool hasShown = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationOne,
          builder: (BuildContext context, Widget child) {
            return Positioned(
              top: (ScreenUtil.instance.setWidth(20) as double) - animationOne.value * sin(pi * widget.startAngle / 180),
              left: (ScreenUtil.instance.setWidth(20) as double)-animationOne.value * cos(pi * widget.startAngle / 180),
              child: child,
            );
          },
          child: widget.expandableTwoButton[0],
        ),
        AnimatedBuilder(
          animation: animationTwo,
          builder: (BuildContext context, Widget child) {
            return Positioned(
              top: (ScreenUtil.instance.setWidth(20) as double)-animationTwo.value *
                  sin(pi * (widget.startAngle - widget.intervalAngle) / 180),
              left: (ScreenUtil.instance.setWidth(20) as double)-animationTwo.value *
                  cos(pi * (widget.startAngle - widget.intervalAngle) / 180),
              child: child,
            );
          },
          child: widget.expandableTwoButton[1],
        ),
        GestureDetector(
          onTap: () {
            if (hasShown) {
              animationController.reverse();
              hasShown = false;
            } else {
              animationController.forward();
              hasShown = true;
            }
          },
          child: widget.mainButton,
        ),
      ],
      alignment: AlignmentDirectional.center,
      overflow: Overflow.visible,
    );
  }

  void _initAnimation() {
    animationController =
        AnimationController(duration: Duration(milliseconds: 250), vsync: this);
    animationOne =
        Tween(begin: 0.0, end: widget.radius).animate(animationController);
    animationTwo =
        Tween(begin: 0.0, end: widget.radius).animate(animationController);
  }

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
