import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class NewProButton extends StatefulWidget {
  final Color mainColor;
  final String proIcon;

  const NewProButton({
    super.key,
    required this.mainColor,
    required this.proIcon,
  });

  @override
  State<NewProButton> createState() => _NewProButtonState();
}

class _NewProButtonState extends State<NewProButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 100, end: -100).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (mounted) _controller.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) _controller.forward();
        });
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(alignment: Alignment.center, children: [
        Container(
          height: 40,
          width: 80,
          decoration: BoxDecoration(
            color: widget.mainColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: widget.mainColor,
              width: 2,
            ),
          ),
          padding: const EdgeInsets.all(3),
          child: IconWidget(icon: widget.proIcon, width: 1),
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (_, __) => Transform.translate(
            offset: Offset(_animation.value, 0),
            child: Transform.rotate(
              angle: -pi / 4,
              child: Container(
                width: 40 * sqrt(2),
                height: 1,
                decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                    blurRadius: 1,
                  )
                ]),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
