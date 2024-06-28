import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FloatDirection {
  int xDirection;
  int yDirection;

  FloatDirection(this.xDirection, this.yDirection);
}

class FloatingAnimation extends StatefulWidget {
  final double buttonHeight;

  const FloatingAnimation({super.key, required this.buttonHeight});

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation> {
  double originalWidth = 0;
  double originalHeight = 0;

  // Initial positions
  double triangleX = 0;
  double triangleY = 0;

  double circleX = 0;
  double circleY = 0;

  double halfCircleX = 0;
  double halfCircleY = 0;

  double starX = 0;
  double starY = 0;

  // Initial directions
  FloatDirection starDirection = FloatDirection(-1, 1);
  FloatDirection circleDirection = FloatDirection(-1, -1);
  FloatDirection halfCircleDirection = FloatDirection(1, -1);
  FloatDirection triangleDirection = FloatDirection(1, 1);

  final double iconSize = 25.0;
  double rotationCounter = 0;

  late Timer _animationTimer;

  @override
  void initState() {
    // Setup initial positions
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        originalWidth = MediaQuery.of(context).size.width;
        originalHeight = widget.buttonHeight;

        triangleX = 0;
        triangleY = originalHeight / 2;

        starX = originalWidth / 3;
        starY = 0;

        halfCircleX = -originalWidth / 3;
        halfCircleY = 0;

        circleX = 0;
        circleY = -originalHeight / 2;
      });
    });

    // Start animations
    _animationTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      _checkDirection();
      _animate();
    });

    super.initState();
  }

  _checkDirection() {
    double xLimit = originalWidth / 2 - 10;
    double yLimit = originalHeight / 2 - 10;

    _updateDirection('x', halfCircleX, xLimit, halfCircleDirection);
    _updateDirection('x', circleX, xLimit, circleDirection);
    _updateDirection('x', triangleX, xLimit, triangleDirection);
    _updateDirection('x', starX, xLimit, starDirection);

    _updateDirection('y', halfCircleY, yLimit, halfCircleDirection);
    _updateDirection('y', circleY, yLimit, circleDirection);
    _updateDirection('y', triangleY, yLimit, triangleDirection);
    _updateDirection('y', starY, yLimit, starDirection);
  }

  _updateDirection(
      String type, double position, double limit, FloatDirection direction) {
    if (type == 'x') {
      if (position > limit) {
        direction.xDirection = -1;
      } else if (position < -limit) {
        direction.xDirection = 1;
      }
    } else {
      if (position > limit) {
        direction.yDirection = -1;
      } else if (position < -limit) {
        direction.yDirection = 1;
      }
    }
  }

  _animate() {
    double disposition = 0.5;
    setState(() {
      halfCircleX += disposition * halfCircleDirection.xDirection;
      circleX += disposition / 2 * circleDirection.xDirection;
      starX += disposition / 3 * starDirection.xDirection;
      triangleX += disposition / 5 * triangleDirection.xDirection;

      halfCircleY += disposition * halfCircleDirection.yDirection;
      circleY += disposition * circleDirection.yDirection;
      starY += disposition * starDirection.yDirection;
      triangleY += disposition * triangleDirection.yDirection;

      rotationCounter += 0.02;
    });
  }

  @override
  void dispose() {
    _animationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        _buildIcon(circleX, circleY, 'floating_circle'),
        _buildIcon(halfCircleX, halfCircleY, 'floating_dna'),
        _buildIcon(starX, starY, 'floating_star'),
        _buildIcon(triangleX, triangleY, 'floating_triangle'),
      ],
    );
  }

  _buildIcon(double x, double y, String image) => Transform.translate(
      offset: Offset(x, y),
      child: Transform.rotate(
          angle: rotationCounter,
          child: Image.asset('assets/images/$image.png', height: iconSize)));
}
