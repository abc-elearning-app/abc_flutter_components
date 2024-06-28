import 'dart:math';

import 'package:flutter/material.dart';

class SprinkleEffect extends StatefulWidget {
  final double height;
  final int speed;
  final int fallDirection;
  final double additionalOffsetY;

  final int rows;

  const SprinkleEffect({
    super.key,
    this.rows = 3,
    this.height = 250,
    this.speed = 3,
    this.fallDirection = 80,
    this.additionalOffsetY = 0,
  });

  @override
  State<SprinkleEffect> createState() => _SprinkleEffectState();
}

class _SprinkleEffectState extends State<SprinkleEffect>
    with TickerProviderStateMixin {
  late List<AnimationController> animationControllers;
  late List<Animation<double>> animations;

  @override
  void initState() {
    // Add controllers for each triangle
    animationControllers = List.generate(
        widget.rows * 10,
        (_) => AnimationController(
            vsync: this, duration: Duration(seconds: widget.speed)));

    // Animate the controllers
    animations = List.generate(
        widget.rows * 10,
        (index) => Tween<double>(begin: 0, end: 1)
            .animate(animationControllers[index]));

    // Set random forward time and repeat
    for (AnimationController controller in animationControllers) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.forward(from: 0);
        }
      });

      Future.delayed(
          Duration(seconds: Random().nextInt(3)), () => controller.forward());
    }
    super.initState();
  }

  @override
  void dispose() {
    for (AnimationController controller in animationControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final random = Random();
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.rows,
          itemBuilder: (_, colIndex) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(10, (rowIndex) {
                // Random data
                final offsetX = random.nextInt(50).toDouble();
                final offsetY = random.nextInt(50).toDouble();
                final angle = random.nextInt(360).toDouble();
                final color = _getRandomColor(random);

                return AnimatedBuilder(
                  animation: animationControllers[colIndex * 10 + rowIndex],
                  builder: (_, __) => Transform.translate(
                    offset: Offset(
                        _calculateOffsetX(offsetX, colIndex, rowIndex),
                        _calculateOffsetY(colIndex, rowIndex, offsetY)),
                    child: Transform.rotate(
                      angle: angle,
                      child: CustomPaint(
                        size: const Size(8, 8),
                        painter: TrianglePainter(color: color),
                      ),
                    ),
                  ),
                );
              }))),
    );
  }

  double _calculateOffsetX(double offsetX, int colIndex, int rowIndex) =>
      offsetX -
      animationControllers[colIndex * 10 + rowIndex].value *
          widget.fallDirection;

  double _calculateOffsetY(int colIndex, int rowIndex, double randomOffsetY) =>
      animationControllers[colIndex * 10 + rowIndex].value == 0
          ? -10000
          : animationControllers[colIndex * 10 + rowIndex].value *
                  widget.height -
              randomOffsetY +
              widget.additionalOffsetY;

  Color _getRandomColor(Random random) => Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
}

class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
