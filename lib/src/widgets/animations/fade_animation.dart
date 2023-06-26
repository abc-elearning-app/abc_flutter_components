import 'dart:async';

import 'package:flutter/material.dart';

class FadeScaleAnimation extends StatefulWidget {
  final int delay;
  final int duration;
  final Widget child;

  const FadeScaleAnimation({
    Key? key,
    required this.child,
    this.delay = 10,
    this.duration = 200,
  }) : super(key: key);

  @override
  FadeScaleAnimationState createState() => FadeScaleAnimationState();
}

class FadeScaleAnimationState extends State<FadeScaleAnimation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    disposed = false;
    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    _fadeAnimation = _animationController.drive(Tween<double>(
      begin: 0,
      end: 1,
    ));
    _scaleAnimation = _animationController.drive(Tween<double>(
      begin: 0.9,
      end: 1,
    ));
    Timer(Duration(milliseconds: widget.delay), () {
      if (!disposed) {
        onAnimated();
      }
    });
  }

  void onAnimated() {
    if (!disposed) {
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    disposed = true;
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}
