import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class PathStartImage extends StatefulWidget {
  final DrawType drawType;
  final String imagePath;

  const PathStartImage({
    super.key,
    required this.imagePath,
    required this.drawType,
  });

  @override
  State<PathStartImage> createState() => _PathStartImageState();
}

class _PathStartImageState extends State<PathStartImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    // Only show animation on 1st time open
    if (widget.drawType == DrawType.firstTimeOpen) {
      _controller = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300));

      _animation = Tween<double>(begin: 100, end: 0).animate(_controller);

      Future.delayed(
          const Duration(milliseconds: 200), () => _controller.forward());
    }
    super.initState();
  }

  @override
  void dispose() {
    if (widget.drawType == DrawType.firstTimeOpen) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      right: 20,
      child: widget.drawType == DrawType.firstTimeOpen
          ? AnimatedBuilder(
              animation: _animation,
              builder: (_, __) => Transform.translate(
                  offset: Offset(_animation.value, 0),
                  child: Image.asset('assets/images/path_start.png')),
            )
          : Image.asset('assets/images/path_start.png'),
    );
  }
}
