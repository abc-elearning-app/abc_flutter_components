import 'package:flutter/material.dart';

import '../index.dart';

class BorderAnimation extends StatefulWidget {
  final String label;
  final Widget child;
  final Widget actions;
  final Color textColor;

  const BorderAnimation({
    Key? key,
    required this.child,
    required this.label,
    required this.textColor,
    required this.actions,
  }) : super(key: key);

  @override
  BorderAnimationState createState() => BorderAnimationState();
}

class BorderAnimationState extends State<BorderAnimation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation =
        _animationController.drive(Tween<double>(begin: 0.9, end: 1));
    _animationController.forward();
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

  String get label => widget.label;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.only(top: 0, bottom: 20),
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                shadows: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 4),
                  )
                ]),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: AnimatedContainer(
                        constraints: const BoxConstraints(minWidth: 180),
                        height: 20,
                        duration: const Duration(milliseconds: 300),
                        alignment: Alignment.centerLeft,
                        color: Theme.of(context).colorScheme.surface,
                        child: TextAnimation(label,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: widget.textColor,
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: widget.actions,
                    )
                  ],
                ),
                const SizedBox(height: 10),
                widget.child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
