import 'dart:async';

import 'package:flutter/material.dart';

class OpacityAnimation extends StatefulWidget {
  final Widget child;
  final double startValue;
  final double endValue;
  final int duration;
  final int delay;
  final bool isReverse;
  final Curve curve;
  final bool isUpdate;

  const OpacityAnimation({
    super.key,
    required this.child,
    required this.startValue,
    required this.endValue,
    required this.duration,
    this.delay = 0,
    this.isReverse = false,
    this.curve = Curves.linear,
    this.isUpdate = false,
  });

  @override
  State<OpacityAnimation> createState() => _OpacityAnimationState();
}

class _OpacityAnimationState extends State<OpacityAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool enable = true;
  bool isDisplayChild = false;
  bool disposed = false;

  @override
  void initState() {
    super.initState();
    disposed = false;
    _animationController = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
  }

  @override
  void dispose() {
    disposed = true;
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fadeAnimation =
        Tween(begin: widget.startValue, end: widget.endValue).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(0.0, 0.75, curve: widget.curve),
      ),
    );
    if (!widget.isUpdate) {
      Timer(Duration(milliseconds: widget.delay), () {
        if (!disposed) {
          _animationController.forward();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isUpdate) {
      if (widget.isReverse && _animationController.isCompleted) {
        _animationController.reverse();
      }
      if (!widget.isReverse && !_animationController.isCompleted) {
        _animationController.forward();
      }
    }
    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.child,
    );
  }
}
