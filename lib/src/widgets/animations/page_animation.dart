import 'package:flutter/material.dart';

class PageAnimation extends StatefulWidget {
  final Widget nextChild;
  final Widget? prevChild;

  const PageAnimation({super.key, required this.nextChild, this.prevChild});

  @override
  PageAnimationState createState() => PageAnimationState();
}

class PageAnimationState extends State<PageAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _insideAnimation;
  late Animation<Offset> _outsideAnimation;

  Duration get duration => const Duration(milliseconds: 300);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: duration, vsync: this);
    _insideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: const Offset(0, 0),
    ).animate(_animationController);
    _outsideAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(_animationController);
    onAnimated();
  }

  void onAnimated() {
    _animationController.reset();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.prevChild == null) {
      return widget.nextChild;
    }
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Stack(
          children: [
            SlideTransition(
              position: _outsideAnimation,
              child: widget.prevChild,
            ),
            SlideTransition(
              position: _insideAnimation,
              child: widget.nextChild,
            )
          ],
        );
      },
    );
  }
}
