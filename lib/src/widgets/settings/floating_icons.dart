import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class FloatDirection {
  int xDirection;
  int yDirection;

  FloatDirection(this.xDirection, this.yDirection);
}

class FloatingAnimation extends StatefulWidget {
  final double buttonHeight;
  final String circleIcon;
  final String dnaIcon;
  final String starIcon;
  final String triangleIcon;

  const FloatingAnimation({
    super.key,
    required this.buttonHeight,
    required this.circleIcon,
    required this.dnaIcon,
    required this.starIcon,
    required this.triangleIcon,
  });

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

  double dnaX = 0;
  double dnaY = 0;

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

        dnaX = -originalWidth / 3;
        dnaY = 0;

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

    _updateDirection('x', dnaX, xLimit, halfCircleDirection);
    _updateDirection('x', circleX, xLimit, circleDirection);
    _updateDirection('x', triangleX, xLimit, triangleDirection);
    _updateDirection('x', starX, xLimit, starDirection);

    _updateDirection('y', dnaY, yLimit, halfCircleDirection);
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
      dnaX += disposition * halfCircleDirection.xDirection;
      circleX += disposition / 2 * circleDirection.xDirection;
      starX += disposition / 3 * starDirection.xDirection;
      triangleX += disposition / 5 * triangleDirection.xDirection;

      dnaY += disposition * halfCircleDirection.yDirection;
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
        _buildIcon(circleX, circleY, widget.circleIcon),
        _buildIcon(dnaX, dnaY, widget.dnaIcon),
        _buildIcon(starX, starY, widget.starIcon),
        _buildIcon(triangleX, triangleY, widget.triangleIcon),
      ],
    );
  }

  _buildIcon(double x, double y, String image) => Transform.translate(
      offset: Offset(x, y),
      child: Transform.rotate(
          angle: rotationCounter,
          child: IconWidget(icon: image, height: iconSize)));
}
