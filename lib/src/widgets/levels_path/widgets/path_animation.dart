import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

enum DrawType { noAnimation, firstTimeOpen, nextLevel }

class PathAnimation extends StatefulWidget {
  final DrawType drawType;
  final Color lineColor;
  final int upperRowCount;
  final int lowerRoundCount;
  final int lastCycleLevelCount;
  final int cycles;
  final Duration cycleDrawSpeed;
  final Duration lastCycleDrawSpeed;

  const PathAnimation({
    super.key,
    required this.drawType,
    required this.cycles,
    required this.lastCycleLevelCount,
    required this.upperRowCount,
    required this.lowerRoundCount,
    required this.cycleDrawSpeed,
    required this.lastCycleDrawSpeed,
    this.lineColor = const Color(0xFFE3A651),
  });

  @override
  _PathAnimationState createState() => _PathAnimationState();
}

class _PathAnimationState extends State<PathAnimation>
    with TickerProviderStateMixin {
  List<AnimationController> lineControllers = [];
  List<AnimationController> curveControllers = [];

  List<AnimationController> lastRoundLineControllers = [];
  late AnimationController lastCycleCurveController;

  late AnimationController nextLevelController;
  late AnimationController additionalNextLevelController;

  @override
  void initState() {
    super.initState();

    lastCycleCurveController = AnimationController(
        vsync: this,
        duration: widget.cycleDrawSpeed - const Duration(milliseconds: 100));
    nextLevelController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    additionalNextLevelController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    switch (widget.drawType) {
      case DrawType.firstTimeOpen:
        _setupFirstTimeOpen();
        break;
      case DrawType.nextLevel:
        _setupNextLevelAnimation();
        break;
      default:
        break;
    }
  }

  _setupFirstTimeOpen() {
    if (!mounted) {
      return;
    }

    /// Add controllers for last cycle

    // Controller for upper row
    lastRoundLineControllers.add(
        AnimationController(vsync: this, duration: widget.lastCycleDrawSpeed));

    // If there exist lower row
    if (widget.lastCycleLevelCount > widget.upperRowCount) {
      // Lower row controller
      lastRoundLineControllers.add(AnimationController(
          vsync: this, duration: widget.lastCycleDrawSpeed));
    }

    // Connect last cycle controllers
    if (widget.lastCycleLevelCount > widget.upperRowCount) {
      // draw to the curve
      lastRoundLineControllers[0].addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          lastCycleCurveController.forward();
        }
      });

      // draw the lower line
      lastCycleCurveController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          lastRoundLineControllers[1].forward();
        }
      });
    }

    /// Add controllers for previous rounds (if exist)
    if (widget.cycles == 0) {
      // Start the animation if there's no round
      lastRoundLineControllers[0].forward();
    } else {
      // Add animation controllers (each round have 2 lines + 2 curves)
      // -> double the rounds
      for (int i = 1; i <= widget.cycles * 2; i++) {
        // Add lines
        lineControllers.add(
            AnimationController(vsync: this, duration: widget.cycleDrawSpeed));

        // Add curves
        curveControllers.add(
            AnimationController(vsync: this, duration: widget.cycleDrawSpeed));
      }

      // Connect controllers for all parts of rounds
      for (int i = 1; i <= widget.cycles; i++) {
        lineControllers[(i * 2 - 1) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            curveControllers[(i * 2 - 1) - 1].forward();
          }
        });

        curveControllers[(i * 2 - 1) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            lineControllers[(i * 2) - 1].forward();
          }
        });

        lineControllers[(i * 2) - 1].addStatusListener((status) {
          if (status == AnimationStatus.completed && mounted) {
            curveControllers[(i * 2) - 1].forward();
          }
        });

        if (i == widget.cycles) {
          if (lastRoundLineControllers.isNotEmpty) {
            curveControllers[(i * 2) - 1].addStatusListener((status) {
              if (status == AnimationStatus.completed && mounted) {
                // After finishing all cycles, draw the last cycles
                lastRoundLineControllers[0].forward();
              }
            });
          }
        } else if (lineControllers.length >= i * 2 + 1) {
          curveControllers[(i * 2) - 1].addStatusListener((status) {
            if (status == AnimationStatus.completed && mounted) {
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
    if (!mounted) {
      return;
    }

    nextLevelController.forward();

    if (widget.lastCycleLevelCount == 1 ||
        widget.lastCycleLevelCount == widget.upperRowCount + 1) {
      nextLevelController.addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          additionalNextLevelController.forward();
        }
      });
    }
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
            lastCycleCurveController,
            additionalNextLevelController,
          ],
        ]),
        builder: (_, __) => CustomPaint(
          painter: PathLine(
              drawType: widget.drawType,
              lineColor: widget.lineColor,
              cycles: widget.cycles,
              lastCycleLevelCount: widget.lastCycleLevelCount,
              upperRowCount: widget.upperRowCount,
              lowerRowCount: widget.lowerRoundCount,
              curveControllers: curveControllers,
              lineControllers: lineControllers,
              lastRoundLineControllers: lastRoundLineControllers,
              lastRoundCurveController: lastCycleCurveController,
              nextLevelController: nextLevelController,
              additionalNextLevelController: additionalNextLevelController),
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
    lastCycleCurveController.dispose();
    for (var item in lastRoundLineControllers) {
      item.dispose();
    }
    super.dispose();
  }
}

class PathLine extends CustomPainter {
  final DrawType drawType;
  final Color lineColor;
  final int cycles;
  final int lastCycleLevelCount;
  final int upperRowCount;
  final int lowerRowCount;
  final List<AnimationController> lineControllers;
  final List<AnimationController> curveControllers;
  final List<AnimationController> lastRoundLineControllers;
  final AnimationController lastRoundCurveController;
  final AnimationController nextLevelController;
  final AnimationController additionalNextLevelController;

  PathLine(
      {required this.drawType,
      required this.lineColor,
      required this.cycles,
      required this.lastCycleLevelCount,
      required this.upperRowCount,
      required this.lowerRowCount,
      required this.lineControllers,
      required this.curveControllers,
      required this.lastRoundLineControllers,
      required this.lastRoundCurveController,
      required this.nextLevelController,
      required this.additionalNextLevelController});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lineColor
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.square
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.bevel;

    _drawLine(canvas, paint, size, drawType);
  }

  void _drawLine(
    Canvas canvas,
    Paint paint,
    Size size,
    DrawType drawType,
  ) {
    double startX = 0;
    double endX = 0;
    double startY = 0;
    double endY = 0;
    double centerX = 0;
    double centerY = 0;
    double startAngle = -pi / 2;
    double sweepAngle = 0;
    double radius = size.height / 2;
    double roundHeight = size.height / 2;

    /// Draw complete cycles
    for (int i = 1; i <= cycles; i++) {
      // First Line (1st line of 1st cycle if different)
      startX = i == 1
          ? size.width - size.width / (upperRowCount + 1)
          : size.width * 0.8;
      startY = roundHeight;

      endX = size.width * 0.2;
      endY = startY;

      if (drawType != DrawType.firstTimeOpen) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      } else if (lineControllers[(i * 2 - 1) - 1].value > 0) {
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

      // First Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = -pi;

      if (drawType != DrawType.firstTimeOpen) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      } else if (curveControllers[(i * 2 - 1) - 1].value > 0) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle * curveControllers[(i * 2 - 1) - 1].value,
          false,
          paint,
        );
      }

      // Second Line
      startX = endX;
      startY = endY + size.height;

      endX = size.width * 0.8;
      endY = startY;

      if (drawType != DrawType.firstTimeOpen) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );
      } else if (lineControllers[(i * 2) - 1].value > 0) {
        canvas.drawLine(
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, lineControllers[(i * 2) - 1].value) ?? 0,
            lerpDouble(startY, endY, lineControllers[(i * 2) - 1].value) ?? 0,
          ),
          paint,
        );
      }

      // Second Arc
      centerX = endX;
      centerY = endY + radius;
      sweepAngle = pi;

      if (drawType == DrawType.noAnimation) {
        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );
      } else if (drawType == DrawType.firstTimeOpen) {
        if (curveControllers[(i * 2) - 1].value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * curveControllers[(i * 2) - 1].value,
            false,
            paint,
          );
        }
      } else if (lastCycleLevelCount == 1 && i == cycles) {
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

    /// Draw last cycle
    if (drawType != DrawType.nextLevel) {
      if (lastCycleLevelCount <= upperRowCount) {
        // If there is no previous complete cycles, starting point is different
        startX = cycles == 0
            ? size.width - (size.width / (upperRowCount + 1))
            : size.width * 0.8;
        startY = roundHeight;

        endX = size.width -
            ((size.width / (upperRowCount + 1)) * lastCycleLevelCount);
        endY = startY;

        if (drawType != DrawType.firstTimeOpen) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(endX, endY),
            paint,
          );
        } else if (lastRoundLineControllers[0].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[0].value) ?? 0,
              lerpDouble(startY, endY, lastRoundLineControllers[0].value) ?? 0,
            ),
            paint,
          );
        }
      } else {
        double upperStartX = cycles == 0
            ? size.width - (size.width / (upperRowCount + 1))
            : size.width * 0.8;
        double upperStartY = roundHeight;

        double upperEndX = size.width * 0.2;
        double upperEndY = upperStartY;

        if (drawType != DrawType.firstTimeOpen) {
          canvas.drawLine(
            Offset(upperStartX, upperStartY),
            Offset(upperEndX, upperEndY),
            paint,
          );
        } else if (lastRoundLineControllers[0].value > 0) {
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

        // Draw the arc
        centerX = upperEndX;
        centerY = upperEndY + size.height / 2;
        sweepAngle = -pi;
        if (drawType != DrawType.firstTimeOpen) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle,
            false,
            paint,
          );
        } else if (lastRoundCurveController.value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * lastRoundCurveController.value,
            false,
            paint,
          );
        }

        startX = centerX;
        startY = centerY + size.height / 2;

        endX = (size.width / (lowerRowCount + 1)) *
            (lastCycleLevelCount - upperRowCount);
        endY = startY;

        if (drawType != DrawType.firstTimeOpen) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(endX, endY),
            paint,
          );
        } else if (lastRoundLineControllers[1].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, lastRoundLineControllers[1].value) ?? 0,
              lerpDouble(startY, endY, lastRoundLineControllers[1].value) ?? 0,
            ),
            paint,
          );
        }
      }
    } else {
      if (lastCycleLevelCount == 1) {
        startX = cycles != 0
            ? size.width * 0.8
            : size.width - (size.width / (upperRowCount + 1));
        startY = centerY + size.height / 2;

        endX = size.width - (size.width / (upperRowCount + 1));
        endY = startY;

        if (additionalNextLevelController.value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, additionalNextLevelController.value) ??
                  0,
              lerpDouble(startY, endY, additionalNextLevelController.value) ??
                  0,
            ),
            paint,
          );
        }
      } else if (lastCycleLevelCount <= upperRowCount) {
        startX = cycles != 0
            ? size.width * 0.8
            : size.width - (size.width / (upperRowCount + 1));
        startY = centerY + size.height / 2;

        endX = size.width -
            (size.width / (upperRowCount + 1)) * (lastCycleLevelCount - 1);
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );

        startX = endX;
        startY = endY;

        endX = startX - size.width / (upperRowCount + 1);
        endY = startY;

        if (nextLevelController.value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, nextLevelController.value) ?? 0,
              lerpDouble(startY, endY, nextLevelController.value) ?? 0,
            ),
            paint,
          );
        }
      } else if (lastCycleLevelCount == upperRowCount + 1) {
        startX = cycles != 0
            ? size.width * 0.8
            : size.width - (size.width / (upperRowCount + 1));
        startY = centerY + size.height / 2;

        endX = size.width * 0.2;
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );

        centerX = endX;
        centerY = endY + size.height / 2;
        sweepAngle = -pi;

        if (nextLevelController.value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * nextLevelController.value,
            false,
            paint,
          );
        }

        startX = centerX;
        startY = centerY + size.height / 2;

        endX = size.width / (lowerRowCount + 1);
        endY = startY;

        if (additionalNextLevelController.value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX, additionalNextLevelController.value) ??
                  0,
              lerpDouble(startY, endY, additionalNextLevelController.value) ??
                  0,
            ),
            paint,
          );
        }
      } else {
        startX = cycles != 0
            ? size.width * 0.8
            : size.width - (size.width / (upperRowCount + 1));
        startY = centerY + size.height / 2;

        endX = size.width * 0.2;
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );

        centerX = endX;
        centerY = endY + size.height / 2;
        sweepAngle = -pi;

        canvas.drawArc(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
          startAngle,
          sweepAngle,
          false,
          paint,
        );

        startX = centerX;
        startY = centerY + size.height / 2;

        endX = (size.width / (lowerRowCount + 1)) *
            (lastCycleLevelCount - upperRowCount - 1);
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint,
        );

        startX = endX;
        startY = endY;

        endX = startX + size.width / (lowerRowCount + 1);
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(
            lerpDouble(startX, endX, nextLevelController.value) ?? 0,
            lerpDouble(startY, endY, nextLevelController.value) ?? 0,
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
