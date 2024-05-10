import 'package:flutter/material.dart';

class MovedAnimation extends StatefulWidget {
  final Widget? firstChild;
  final Widget? secondChild;

  const MovedAnimation({super.key, this.firstChild, this.secondChild});

  @override
  MovedAnimationState createState() => MovedAnimationState();
}

class MovedAnimationState extends State<MovedAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController1;
  late Animation<Offset> _animation1, _animation2;

  // Widget child;

  @override
  void initState() {
    super.initState();
    _animationController1 =
        AnimationController(duration: Duration(milliseconds: 1000), vsync: this);
    _animation1 = _animationController1
        .drive(Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)));
    _animation2 = _animationController1
        .drive(Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)));
    onAnimation();
  }

  void onAnimation() {
    _animationController1.reset();
    _animationController1.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SlideTransition(
          position: _animation1,
          child: widget.firstChild,
        ),
        SlideTransition(
          position: _animation2,
          child: widget.secondChild,
        ),
      ],
    );
  }
}
