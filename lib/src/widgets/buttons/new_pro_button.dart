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
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 5));
    _animation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 3), () {
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
    return Stack(alignment: Alignment.center, children: [
      ClipRRect(
        clipper: RRectClipper(),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedBuilder(
          animation: _animation,
          builder: (_, __) {
            return Transform.rotate(
              angle: _animation.value,
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [
                      widget.mainColor,
                      Color.lerp(widget.mainColor, Colors.white, 0.5) ?? widget.mainColor,
                    ])),
              ),
            );
          },
        ),
      ),
      Container(
        height: 40,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.mainColor,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.all(3),
        child: IconWidget(icon: widget.proIcon, width: 1),
      ),
    ]);
  }
}

class RRectClipper extends CustomClipper<RRect> {
  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        size.height / 4,
        size.width,
        size.height / 2,
      ),
      const Radius.circular(10),
    );
  }

  @override
  bool shouldReclip(CustomClipper<RRect> oldClipper) => false;
}
