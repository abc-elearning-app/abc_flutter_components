import 'package:flutter/material.dart';

enum PositionType { leftToRight, rightToLeft, topToBottom, bottomToTop }

class SlideTransitionPanel extends StatefulWidget {
  final Widget? child;
  final VoidCallback? onEnd;
  final PositionType? position;

  const SlideTransitionPanel({
    Key? key,
    required this.child,
    this.onEnd,
    this.position,
  }) : super(key: key);

  @override
  SlideTransitionPanelState createState() => SlideTransitionPanelState();
}

class SlideTransitionPanelState extends State<SlideTransitionPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  Offset get offsetBegin {
    switch (widget.position) {
      case PositionType.leftToRight:
        return const Offset(-2, 0);
      case PositionType.rightToLeft:
        return const Offset(0, 2);
      case PositionType.topToBottom:
        return const Offset(0, -2);
      case PositionType.bottomToTop:
        return const Offset(0, 2);
      default:
        return const Offset(2, 0);
    }
  }

  bool disposed = false;

  @override
  void initState() {
    super.initState();
    disposed = false;
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _slideAnimation = _animationController
        .drive(Tween<Offset>(begin: offsetBegin, end: const Offset(0, 0)));
    _animationController.addStatusListener(listen);
    onAnimated();
  }

  void listen(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onEnd?.call();
    }
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
    _animationController.removeStatusListener(listen);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: widget.child,
    );
  }
}
