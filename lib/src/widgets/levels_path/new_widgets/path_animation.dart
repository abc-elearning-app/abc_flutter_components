import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

class PathAnimation extends StatefulWidget {
  final int longRowCount;
  final int shortRowCount;
  final int lastRoundLevelCount;
  final int rounds;
  final bool isDash;
  final Duration roundDrawSpeed;
  final Duration lastRoundDrawSpeed;
  final Color lineColor;

  // Decide to draw animation
  final bool showAnimation;
  final bool isBackground;

  const PathAnimation({
    super.key,
    required this.rounds,
    required this.lastRoundLevelCount,
    required this.longRowCount,
    required this.shortRowCount,
    required this.roundDrawSpeed,
    required this.lastRoundDrawSpeed,
    required this.lineColor,
    this.isDash = false,
    this.isBackground = false,
    required this.showAnimation,
  });

  @override
  _PathAnimationState createState() => _PathAnimationState();
}

class _PathAnimationState extends State<PathAnimation>
    with TickerProviderStateMixin {
  List<AnimationController> lineControllers = [];
  List<AnimationController> curveControllers = [];

  List<AnimationController> lastRoundLineControllers = [];
  late AnimationController lastRoundCurveController;

  late AnimationController nextLevelController;
  late AnimationController smallLineController;

  @override
  void initState() {
    super.initState();

    //tmp
    lastRoundCurveController =
        AnimationController(vsync: this, duration: const Duration());
    nextLevelController =
        AnimationController(vsync: this, duration: const Duration());
    smallLineController =
        AnimationController(vsync: this, duration: const Duration());

    if (widget.showAnimation) {
      _setupFirstTimeOpen();
    } else {
      _setupNextLevelAnimation();
    }
  }

  _setupFirstTimeOpen() {
    // Add controllers for last round first

    // If there is only upper line
    if (widget.lastRoundLevelCount <= widget.longRowCount) {
      for (int i = 0; i < widget.lastRoundLevelCount; i++) {
        lastRoundLineControllers.add(AnimationController(
            vsync: this, duration: widget.lastRoundDrawSpeed));
      }
    } else {
      // If there is the lower line, the upper lines become 1
      lastRoundLineControllers.add(
          AnimationController(vsync: this, duration: widget.roundDrawSpeed));

      // Add the curve to move down
      lastRoundCurveController = AnimationController(
          vsync: this,
          duration: widget.roundDrawSpeed - const Duration(milliseconds: 100));

      // Add lines for the lower levels
      for (int i = 0;
          i < widget.lastRoundLevelCount - widget.longRowCount;
          i++) {
        lastRoundLineControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));
      }
    }

    // Connect last round controllers
    if (1 < widget.lastRoundLevelCount &&
        widget.lastRoundLevelCount <= widget.longRowCount) {
      // Connect upper controllers
      for (int i = 0; i < widget.lastRoundLevelCount - 1; i++) {
        lastRoundLineControllers[i].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lastRoundLineControllers[i + 1].forward();
          }
        });
      }
    } else if (widget.lastRoundLevelCount > widget.longRowCount) {
      // draw to the curve
      lastRoundLineControllers[0].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          lastRoundCurveController.forward();
        }
      });

      // forward the 1st controller of lower line
      lastRoundCurveController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          lastRoundLineControllers[1].forward();
        }
      });

      // draw the rest
      for (int i = 0;
          i < widget.lastRoundLevelCount - widget.longRowCount - 1;
          i++) {
        lastRoundLineControllers[i + 1].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lastRoundLineControllers[i + 2].forward();
          }
        });
      }
    }

    // Add controllers for previous rounds (if exist)
    if (widget.rounds == 0) {
      // Start the animation if there's no round
      if (widget.lastRoundLevelCount > 1) {
        lastRoundLineControllers[0].forward();
      }
    } else {
      // Add animation controllers (each round have 2 lines + 2 curves)
      // -> double the rounds
      for (int i = 1; i <= widget.rounds * 2; i++) {
        // Add lines
        lineControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));

        // Add curves
        curveControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));
      }

      // Connect controllers for all parts of rounds
      for (int i = 1; i <= widget.rounds; i++) {
        lineControllers[(i * 2 - 1) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            curveControllers[(i * 2 - 1) - 1].forward();
          }
        });

        curveControllers[(i * 2 - 1) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lineControllers[(i * 2) - 1].forward();
          }
        });

        lineControllers[(i * 2) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            curveControllers[(i * 2) - 1].forward();
          }
        });

        if (i == widget.rounds) {
          if (lastRoundLineControllers.isNotEmpty) {
            curveControllers[(i * 2) - 1].addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                // After finishing all rounds, draw the last round
                lastRoundLineControllers[0].forward();
              }
            });
          }
        } else if (lineControllers.length >= i * 2 + 1) {
          curveControllers[(i * 2) - 1].addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              lineControllers[(i * 2 + 1) - 1].forward();
            }
          });
        }
      }

      // Start the animation
      lineControllers[0].forward();
    }
  }

  _setupNextLevelAnimation() {
    nextLevelController = AnimationController(
        vsync: this, duration: widget.lastRoundDrawSpeed * 3);
    smallLineController = AnimationController(
        vsync: this, duration: widget.lastRoundDrawSpeed * 2);

    nextLevelController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        smallLineController.forward();
      }
    });
    nextLevelController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          ...lineControllers,
          ...curveControllers,
          ...lastRoundLineControllers,
          ...[
            nextLevelController,
            lastRoundCurveController,
            smallLineController
          ],
        ]),
        builder: (_, __) => CustomPaint(
          painter: PathLine(
              lineColor: widget.lineColor,
              rounds: widget.rounds,
              lastRoundLevelCount: widget.lastRoundLevelCount,
              longRoundCount: widget.longRowCount,
              shortRoundCount: widget.shortRowCount,
              curveControllers: curveControllers,
              lineControllers: lineControllers,
              lastRoundLineControllers: lastRoundLineControllers,
              lastRoundCurveController: lastRoundCurveController,
              nextLevelController: nextLevelController,
              smallLineController: smallLineController,
              isDash: widget.isDash,
              showAnimation: widget.showAnimation,
              isBackground: widget.isBackground),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (AnimationController controller in lineControllers) {
      controller.dispose();
    }
    for (AnimationController controller in curveControllers) {
      controller.dispose();
    }

    nextLevelController.dispose();
    lastRoundCurveController.dispose();
    smallLineController.dispose();
    super.dispose();
  }
}

class PathLine extends CustomPainter {
  final int rounds;
  final int lastRoundLevelCount;
  final int longRoundCount;
  final int shortRoundCount;
  final List<AnimationController> lineControllers;
  final List<AnimationController> curveControllers;
  final List<AnimationController> lastRoundLineControllers;
  final AnimationController lastRoundCurveController;
  final AnimationController nextLevelController;
  final AnimationController smallLineController;
  final bool isDash;
  final Color lineColor;
  final bool showAnimation;
  final bool isBackground;

  PathLine(
      {required this.rounds,
      required this.lastRoundLevelCount,
      required this.longRoundCount,
      required this.shortRoundCount,
      required this.lineControllers,
      required this.curveControllers,
      required this.lastRoundLineControllers,
      required this.lastRoundCurveController,
      required this.nextLevelController,
      required this.smallLineController,
      required this.isDash,
      required this.showAnimation,
      required this.lineColor,
      required this.isBackground});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      // ..color = isDash ? Colors.grey : const Color(0xFF579E89)
      ..color = lineColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;

    if (showAnimation) {
      _drawFirstTimeOpenLine(canvas, paint, size);
    } else if (isBackground) {
      _drawDefaultLine(canvas, paint, size);
    } else {
      _drawNextLevelAnimation(canvas, paint, size);
    }

    // if (isDash) {
    //   if (showAnimation)
    //     _drawFirstTimeOpenDash(canvas, paint, size);
    //   else
    //     _drawDefaultDash(canvas, paint, size);
    // } else {
    //   if (showAnimation)
    //     _drawFirstTimeOpenLine(canvas, paint, size);
    //   else
    //     _drawNextLevelAnimation(canvas, paint, size);
    // }
  }

  // First time open animation
  _drawFirstTimeOpenDash(Canvas canvas, Paint paint, Size size) {
    double startX;
    double endX;
    double startY;
    double endY;
    double centerX;
    double centerY;
    double startAngle = -pi / 2;
    double radius = size.height / 2;
    double roundHeight = size.height / 2;
    int dashArcSegments = 12;

    // Start drawing rounds
    for (int i = 1; i <= rounds; i++) {
      // First Line

      startX = size.width * 0.2;
      startY = roundHeight;

      endX = size.width * 0.8;
      endY = roundHeight;

      if (lineControllers[(i * 2 - 1) - 1].value > 0) {
        _drawDashedLine(
          canvas,
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, lineControllers[(i * 2 - 1) - 1].value) ??
                0,
            lerpDouble(startY, endY, lineControllers[(i * 2 - 1) - 1].value) ??
                0,
          ),
          paint,
        );
      }

      // First Circle
      centerX = endX;
      centerY = endY + radius;

      if (curveControllers[(i * 2 - 1) - 1].value > 0) {
        _drawDashedArc(
          canvas: canvas,
          segment: dashArcSegments,
          rect:
              Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle: startAngle,
          clockwise: true,
          value: curveControllers[(i * 2 - 1) - 1].value,
          paint: paint,
        );
      }

      // Second Line
      final tmpOldStartX = startX;
      final tmpOldStartY = startY;

      startX = endX;
      startY = endY + size.height;

      endX = tmpOldStartX;
      endY = tmpOldStartY + size.height;

      if (lineControllers[(i * 2) - 1].value > 0) {
        _drawDashedLine(
          canvas,
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, lineControllers[(i * 2) - 1].value) ?? 0,
            lerpDouble(startY, endY, lineControllers[(i * 2) - 1].value) ?? 0,
          ),
          paint,
        );
      }

      // Second Circle
      centerX = endX;
      centerY = endY + radius;

      if (curveControllers[(i * 2) - 1].value > 0) {
        _drawDashedArc(
          canvas: canvas,
          segment: dashArcSegments,
          rect:
              Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle: startAngle,
          clockwise: false,
          value: curveControllers[(i * 2) - 1].value,
          paint: paint,
        );
      }

      roundHeight += size.height * 2;
    }

    // Draw last round
    // if only upper row
    if (lastRoundLevelCount <= longRoundCount) {
      double lastRoundStartX = size.width * 0.2;
      double lastRoundStartY = roundHeight;
      final longRowLength = size.width / (longRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? longRowLength : startX + longRowLength;
        endY = startY;

        if (lastRoundLineControllers[i].value > 0) {
          _drawDashedLine(
            canvas,
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[i].value) ?? 0,
              lerpDouble(startY, endY, lastRoundLineControllers[i].value) ?? 0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }
    } else {
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      if (lastRoundLineControllers[0].value > 0) {
        _drawDashedLine(
          canvas,
          Offset(upperStartX, upperStartY),
          Offset(
            lerpDouble(upperStartX, upperEndX,
                    lastRoundLineControllers[0].value) ??
                0,
            lerpDouble(upperStartY, upperEndY,
                    lastRoundLineControllers[0].value) ??
                0,
          ),
          paint,
        );
      }

      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      if (lastRoundCurveController.value > 0) {
        _drawDashedArc(
          canvas: canvas,
          segment: dashArcSegments,
          rect:
              Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle: startAngle,
          clockwise: true,
          value: lastRoundCurveController.value,
          paint: paint,
        );
      }

      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (shortRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount - longRoundCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX =
            i == 0 ? shortRoundCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        if (lastRoundLineControllers[i + 1].value > 0) {
          _drawDashedLine(
            canvas,
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[i + 1].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i + 1].value) ??
                  0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }
    }
  }

  _drawFirstTimeOpenLine(Canvas canvas, Paint paint, Size size) {
    double startX;
    double endX;
    double startY;
    double endY;
    double centerX;
    double centerY;
    double startAngle = -pi / 2;
    double sweepAngle;
    double radius = size.height / 2;
    double roundHeight = size.height / 2;

    // Start drawing rounds
    for (int i = 1; i <= rounds; i++) {
      // First Line

      startX = size.width * 0.2;
      startY = roundHeight;

      endX = size.width * 0.8;
      endY = roundHeight;

      if (lineControllers[(i * 2 - 1) - 1].value > 0) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, lineControllers[(i * 2 - 1) - 1].value) ??
                0,
            lerpDouble(startY, endY, lineControllers[(i * 2 - 1) - 1].value) ??
                0,
          ),
          paint,
        );
      }

      // First Circle
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = pi;

      if (curveControllers[(i * 2 - 1) - 1].value > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle * curveControllers[(i * 2 - 1) - 1].value,
          false,
          paint,
        );
      }

      // Second Line
      final tmpOldStartX = startX;
      final tmpOldStartY = startY;

      startX = endX;
      startY = endY + size.height;

      endX = tmpOldStartX;
      endY = tmpOldStartY + size.height;

      if (lineControllers[(i * 2) - 1].value > 0) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, lineControllers[(i * 2) - 1].value) ?? 0,
            lerpDouble(startY, endY, lineControllers[(i * 2) - 1].value) ?? 0,
          ),
          paint,
        );
      }

      // Second Circle
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = -pi;

      if (curveControllers[(i * 2) - 1].value > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle * curveControllers[(i * 2) - 1].value,
          false,
          paint,
        );
      }

      roundHeight += size.height * 2;
    }

    // Draw last round
    // if only upper row
    if (lastRoundLevelCount <= longRoundCount) {
      double lastRoundStartX = size.width * 0.2;
      double lastRoundStartY = roundHeight;
      final longRowLength = size.width / (longRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? longRowLength : startX + longRowLength;
        endY = startY;

        if (lastRoundLineControllers[i].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[i].value) ?? 0,
              lerpDouble(startY, endY, lastRoundLineControllers[i].value) ?? 0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }
    } else {
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      if (lastRoundLineControllers[0].value > 0) {
        canvas.drawLine(
          Offset(upperStartX, upperStartY),
          Offset(
            lerpDouble(upperStartX, upperEndX,
                    lastRoundLineControllers[0].value) ??
                0,
            lerpDouble(upperStartY, upperEndY,
                    lastRoundLineControllers[0].value) ??
                0,
          ),
          paint,
        );
      }

      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      sweepAngle = pi;
      if (lastRoundCurveController.value > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle * lastRoundCurveController.value,
          false,
          paint,
        );
      }

      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (shortRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount - longRoundCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX =
            i == 0 ? shortRoundCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        if (lastRoundLineControllers[i + 1].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[i + 1].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i + 1].value) ??
                  0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }
    }
  }

  // Next level animation
  _drawNextLevelAnimation(Canvas canvas, Paint paint, Size size) {
    double startX;
    double endX;
    double startY;
    double endY;
    double centerX;
    double centerY;
    double startAngle = -pi / 2;
    double sweepAngle;
    double radius = size.height / 2;
    double roundHeight = size.height / 2;

    /// Start drawing rounds
    for (int i = 1; i <= rounds; i++) {
      // First Line
      startX = size.width * 0.2;
      startY = roundHeight;

      endX = size.width * 0.8;
      endY = roundHeight;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // First Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = pi;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Second Line
      startX = endX;
      startY = endY + size.height;

      endX = size.width * 0.2;
      endY = startY;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Second Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = -pi;

      if (lastRoundLevelCount == 1 && i == rounds) {
        if (nextLevelController.value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * nextLevelController.value,
            false,
            paint,
          );
        }
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }

      roundHeight += size.height * 2;
    }

    /// Draw last round
    // if only upper row
    if (lastRoundLevelCount <= longRoundCount) {
      double lastRoundStartX = size.width * 0.2;
      double lastRoundStartY = roundHeight;
      final longRowLength = size.width / (longRoundCount + 1);

      if (lastRoundLevelCount == 1) {
        for (int i = 0; i < lastRoundLevelCount; i++) {
          startX = lastRoundStartX;
          startY = lastRoundStartY;

          endX = i == 0 ? longRowLength : startX + longRowLength;
          endY = startY;

          if (smallLineController.value > 0) {
            canvas.drawLine(
                Offset(startX, startY),
                Offset(
                  lerpDouble(startX, endX, smallLineController.value) ?? 0,
                  lerpDouble(startY, endY, smallLineController.value) ?? 0,
                ),
                paint);
          }

          lastRoundStartX = endX;
          lastRoundStartY = endY;
        }
      } else {
        for (int i = 0; i < lastRoundLevelCount - 1; i++) {
          startX = lastRoundStartX;
          startY = lastRoundStartY;

          endX = i == 0 ? longRowLength : startX + longRowLength;
          endY = startY;

          canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

          lastRoundStartX = endX;
          lastRoundStartY = endY;
        }

        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = startX + longRowLength;
        endY = startY;

        if (nextLevelController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(lerpDouble(startX, endX, nextLevelController.value) ?? 0,
                  lerpDouble(startY, endY, nextLevelController.value) ?? 0),
              paint);
        }
      }
    } else {
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      canvas.drawLine(Offset(upperStartX, upperStartY),
          Offset(upperEndX, upperEndY), paint);

      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      sweepAngle = pi;
      if (lastRoundLevelCount == longRoundCount + 1) {
        if (nextLevelController.value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * nextLevelController.value,
            false,
            paint,
          );
        }
        double lastRoundStartX = centerX;
        double lastRoundStartY = centerY + size.height / 2;
        final shortRowLength = size.width / (shortRoundCount + 1);

        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = shortRoundCount * shortRowLength;
        endY = startY;

        if (smallLineController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                lerpDouble(startX, endX, smallLineController.value) ?? 0,
                lerpDouble(startY, endY, smallLineController.value) ?? 0,
              ),
              paint);
        }
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }

      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (shortRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount - longRoundCount - 1; i++) {
        if (lastRoundLevelCount == longRoundCount + 1 && i == 0) continue;
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX =
            i == 0 ? shortRoundCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }

      if (lastRoundLevelCount > longRoundCount + 1) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = startX - shortRowLength;
        endY = startY;

        if (nextLevelController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                lerpDouble(startX, endX, nextLevelController.value) ?? 0,
                lerpDouble(startY, endY, nextLevelController.value) ?? 0,
              ),
              paint);
        }
      }
    }
  }

  _drawDefaultLine(Canvas canvas, Paint paint, Size size) {
    double startX;
    double endX;
    double startY;
    double endY;
    double centerX;
    double centerY;
    double startAngle = -pi / 2;
    double sweepAngle;
    double radius = size.height / 2;
    double roundHeight = size.height / 2;

    /// Start drawing rounds
    for (int i = 1; i <= rounds; i++) {
      // First Line
      startX = size.width * 0.2;
      startY = roundHeight;

      endX = size.width * 0.8;
      endY = roundHeight;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // First Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = pi;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Second Line
      startX = endX;
      startY = endY + size.height;

      endX = size.width * 0.2;
      endY = startY;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

      // Second Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = -pi;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      roundHeight += size.height * 2;
    }

    /// Draw last round
    // if only upper row
    if (lastRoundLevelCount <= longRoundCount) {
      double lastRoundStartX = size.width * 0.2;
      double lastRoundStartY = roundHeight;
      final longRowLength = size.width / (longRoundCount + 1);

      if (lastRoundLevelCount == 1) {
        for (int i = 0; i < lastRoundLevelCount; i++) {
          startX = lastRoundStartX;
          startY = lastRoundStartY;

          endX = i == 0 ? longRowLength : startX + longRowLength;
          endY = startY;

          canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

          lastRoundStartX = endX;
          lastRoundStartY = endY;
        }
      } else {
        for (int i = 0; i < lastRoundLevelCount - 1; i++) {
          startX = lastRoundStartX;
          startY = lastRoundStartY;

          endX = i == 0 ? longRowLength : startX + longRowLength;
          endY = startY;

          canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

          lastRoundStartX = endX;
          lastRoundStartY = endY;
        }

        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = startX + longRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    } else {
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      canvas.drawLine(Offset(upperStartX, upperStartY),
          Offset(upperEndX, upperEndY), paint);

      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      sweepAngle = pi;
      if (lastRoundLevelCount == longRoundCount + 1) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );

        double lastRoundStartX = centerX;
        double lastRoundStartY = centerY + size.height / 2;
        final shortRowLength = size.width / (shortRoundCount + 1);

        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = shortRoundCount * shortRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      } else {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      }

      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (shortRoundCount + 1);

      for (int i = 0; i < lastRoundLevelCount - longRoundCount - 1; i++) {
        if (lastRoundLevelCount == longRoundCount + 1 && i == 0) continue;
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX =
            i == 0 ? shortRoundCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }

      if (lastRoundLevelCount > longRoundCount + 1) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = startX - shortRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      }
    }
  }

  // Helper functions
  _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint,
      {double dashWidth = 8, double dashSpace = 16}) {
    double distance = (start - end).distance;
    if (distance == 0) return; // Prevent division by zero or NaN

    double dx = (end.dx - start.dx) / distance;
    double dy = (end.dy - start.dy) / distance;
    double dashLength = dashWidth + dashSpace;

    double startX = start.dx;
    double startY = start.dy;

    while (distance >= 0.0) {
      double endX = startX + dx * dashWidth;
      double endY = startY + dy * dashWidth;
      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
      startX += dx * dashLength;
      startY += dy * dashLength;
      distance -= dashLength;
    }
  }

  _drawDashedArc({
    required Canvas canvas,
    required int segment,
    required Rect rect,
    required double startAngle,
    required bool clockwise,
    required double value,
    required Paint paint,
    double dashWidth = 3,
  }) {
    double sweepAngle =
        (2 * pi / segment) * value; // Calculate sweep angle based on the value

    for (int i = 0; i < segment; i++) {
      if (i % 2 == 0) {
        canvas.drawArc(
          rect,
          startAngle + (clockwise ? (i * pi / segment) : (-i * pi / segment)),
          dashWidth * sweepAngle / segment,
          // Use sweep angle divided by segment count
          false,
          paint..color,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
