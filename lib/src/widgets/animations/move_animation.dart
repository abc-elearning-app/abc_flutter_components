import 'package:flutter/material.dart';

class MoveAnimation extends StatefulWidget {
  final Widget firstChild;
  final Widget secondChild;

  const MoveAnimation({
    Key? key,
    required this.firstChild,
    required this.secondChild,
  }) : super(key: key);

  @override
  MoveAnimationState createState() => MoveAnimationState();
}

class MoveAnimationState extends State<MoveAnimation>
    with TickerProviderStateMixin {
  late AnimationController _animationController1, _animationController2;
  late Animation<Offset> _animation1, _animation2;

  // Widget child;

  @override
  void initState() {
    super.initState();
    _animationController1 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animationController2 = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _animation1 = _animationController1.drive(
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0)));
    _animation2 = _animationController2.drive(
        Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)));
    onAnimation();
  }

  void onAnimation() {
    // _animationController1.reset();
    _animationController2.reset();
    // _animationController1.forward();
    _animationController2.forward();
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
