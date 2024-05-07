import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class PathAnimation extends StatefulWidget {
  final int rowItemCount;
  final int remainingLevelCount;
  final int cycles;
  final Duration roundDrawSpeed;
  final Duration lastRoundDrawSpeed;
  final Color lineColor;

  // Decide to draw animation
  final OpenType type;

  const PathAnimation({
    super.key,
    required this.cycles,
    required this.remainingLevelCount,
    required this.rowItemCount,
    required this.roundDrawSpeed,
    required this.lastRoundDrawSpeed,
    required this.lineColor,
    required this.type,
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

    switch (widget.type) {
      case OpenType.firstTime:
        {
          _setupFirstTimeOpen();
          break;
        }
      case OpenType.nextLevel:
        {
          _setupNextLevelAnimation();
          break;
        }
      case OpenType.normal:
        {}
    }
  }

  _setupFirstTimeOpen() {
    // Add controllers for last round first

    // If there is only upper line
    if (widget.remainingLevelCount <= widget.rowItemCount) {
      for (int i = 0; i < widget.remainingLevelCount; i++) {
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
          i < widget.remainingLevelCount - widget.rowItemCount;
          i++) {
        lastRoundLineControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));
      }
    }

    // Connect last round controllers
    if (1 < widget.remainingLevelCount &&
        widget.remainingLevelCount <= widget.rowItemCount) {
      // Connect upper controllers
      for (int i = 0; i < widget.remainingLevelCount - 1; i++) {
        lastRoundLineControllers[i].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lastRoundLineControllers[i + 1].forward();
          }
        });
      }
    } else if (widget.remainingLevelCount > widget.rowItemCount) {
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
          i < widget.remainingLevelCount - widget.rowItemCount - 1;
          i++) {
        lastRoundLineControllers[i + 1].addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            lastRoundLineControllers[i + 2].forward();
          }
        });
      }
    }

    // Add controllers for previous rounds (if exist)
    if (widget.cycles == 0) {
      // Start the animation if there's no round
      if (widget.remainingLevelCount > 1) {
        lastRoundLineControllers[0].forward();
      }
    } else {
      // Add animation controllers (each round have 2 lines + 2 curves)
      // -> double the rounds
      for (int i = 1; i <= widget.cycles * 2; i++) {
        // Add lines
        lineControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));

        // Add curves
        curveControllers.add(
            AnimationController(vsync: this, duration: widget.roundDrawSpeed));
      }

      // Connect controllers for all parts of rounds
      for (int i = 1; i <= widget.cycles; i++) {
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

        if (i == widget.cycles) {
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
              type: widget.type,
              lineColor: widget.lineColor,
              rounds: widget.cycles,
              lastCycleLevelCount: widget.remainingLevelCount,
              rowItemCount: widget.rowItemCount,
              curveControllers: curveControllers,
              lineControllers: lineControllers,
              lastRoundLineControllers: lastRoundLineControllers,
              lastRoundCurveController: lastRoundCurveController,
              nextLevelController: nextLevelController,
              smallLineController: smallLineController),
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
  final int lastCycleLevelCount;
  final int rowItemCount;
  final List<AnimationController> lineControllers;
  final List<AnimationController> curveControllers;
  final List<AnimationController> lastRoundLineControllers;
  final AnimationController lastRoundCurveController;
  final AnimationController nextLevelController;
  final AnimationController smallLineController;
  final Color lineColor;
  final OpenType type;

  PathLine(
      {required this.rounds,
      required this.lastCycleLevelCount,
      required this.rowItemCount,
      required this.lineControllers,
      required this.curveControllers,
      required this.lastRoundLineControllers,
      required this.lastRoundCurveController,
      required this.nextLevelController,
      required this.smallLineController,
      required this.lineColor,
      required this.type});

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

    _drawLine(canvas, paint, size);

    // if (showAnimation) {
    //   _drawFirstTimeOpenLine(canvas, paint, size);
    // } else if (isBackground) {
    //   _drawDefaultLine(canvas, paint, size);
    // } else {
    //   _drawNextLevelAnimation(canvas, paint, size);
    // }
  }

  _drawLine(Canvas canvas, Paint paint, Size size) {
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

    const disposition = 20;

    // Start drawing cycles
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
    if (lastCycleLevelCount <= rowItemCount) {
      double lastCycleStartX = size.width * 0.2;
      double lastCycleStartY = roundHeight;
      final longRowLength = size.width / (rowItemCount + 1);

      // Draw upper lines
      for (int i = 0; i < lastCycleLevelCount; i++) {
        startX = lastCycleStartX;
        startY = lastCycleStartY;

        endX = i == 0 ? longRowLength : startX + longRowLength;
        endY = startY;

        if (lastRoundLineControllers[i].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX - disposition,
                      lastRoundLineControllers[i].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i].value) ?? 0,
            ),
            paint,
          );
        }

        lastCycleStartX = endX - disposition;
        lastCycleStartY = endY;
      }
    }
    // If have to move to lower row
    else {
      // Draw upper line
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

      // Draw the arc to move down lower row
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

      // Draw lower lines
      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (rowItemCount + 1);

      for (int i = 0; i < lastCycleLevelCount - rowItemCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? rowItemCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        if (lastRoundLineControllers[i + 1].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX + disposition,
                      lastRoundLineControllers[i + 1].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i + 1].value) ??
                  0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX + disposition;
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

    const disposition = 20;

    // Start drawing cycles
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
    if (lastCycleLevelCount <= rowItemCount) {
      double lastCycleStartX = size.width * 0.2;
      double lastCycleStartY = roundHeight;
      final longRowLength = size.width / (rowItemCount + 1);

      // Draw upper lines
      for (int i = 0; i < lastCycleLevelCount; i++) {
        startX = lastCycleStartX;
        startY = lastCycleStartY;

        endX = i == 0 ? longRowLength : startX + longRowLength;
        endY = startY;

        if (lastRoundLineControllers[i].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX - disposition,
                      lastRoundLineControllers[i].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i].value) ?? 0,
            ),
            paint,
          );
        }

        lastCycleStartX = endX - disposition;
        lastCycleStartY = endY;
      }
    }
    // If have to move to lower row
    else {
      // Draw upper line
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

      // Draw the arc to move down lower row
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

      // Draw lower lines
      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (rowItemCount + 1);

      for (int i = 0; i < lastCycleLevelCount - rowItemCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? rowItemCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        if (lastRoundLineControllers[i + 1].value > 0) {
          canvas.drawLine(
            Offset(startX, startY),
            Offset(
              lerpDouble(startX, endX + disposition,
                      lastRoundLineControllers[i + 1].value) ??
                  0,
              lerpDouble(startY, endY, lastRoundLineControllers[i + 1].value) ??
                  0,
            ),
            paint,
          );
        }

        lastRoundStartX = endX + disposition;
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

    const disposition = 20;

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

      if (lastCycleLevelCount == 1 && i == rounds) {
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
    if (lastCycleLevelCount <= rowItemCount) {
      double lastRoundStartX = size.width * 0.2;
      double lastRoundStartY = roundHeight;
      final longRowLength = size.width / (rowItemCount + 1);

      // If there's only 1 level left
      if (lastCycleLevelCount == 1) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = longRowLength;
        endY = startY;

        if (smallLineController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                lerpDouble(startX, endX - disposition,
                        smallLineController.value) ??
                    0,
                lerpDouble(startY, endY, smallLineController.value) ?? 0,
              ),
              paint);
        }
      } else {
        // Draw lines except the last one (for separate animation)
        for (int i = 0; i < lastCycleLevelCount - 1; i++) {
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

        // Draw the last with animation
        if (nextLevelController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                  lerpDouble(startX, endX - disposition,
                          nextLevelController.value) ??
                      0,
                  lerpDouble(startY, endY, nextLevelController.value) ?? 0),
              paint);
        }
      }
    } else {
      // If have to move down lower line, upper lines become 1 line
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      canvas.drawLine(Offset(upperStartX, upperStartY),
          Offset(upperEndX, upperEndY), paint);

      // Draw arc (with animation only if there's 1 level only below)
      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      sweepAngle = pi;
      if (lastCycleLevelCount == rowItemCount + 1) {
        if (nextLevelController.value > 0) {
          canvas.drawArc(
            Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
            startAngle,
            sweepAngle * nextLevelController.value,
            false,
            paint,
          );
        }

        // Draw a small line leading to the level
        double lastRoundStartX = centerX;
        double lastRoundStartY = centerY + size.height / 2;
        final shortRowLength = size.width / (rowItemCount + 1);

        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = rowItemCount * shortRowLength;
        endY = startY;

        if (smallLineController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                lerpDouble(startX, endX + disposition,
                        smallLineController.value) ??
                    0,
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

      // Draw lower lines except the last one (for separate animation)
      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (rowItemCount + 1);

      for (int i = 0; i < lastCycleLevelCount - rowItemCount - 1; i++) {
        if (lastCycleLevelCount == rowItemCount + 1 && i == 0) continue;
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? rowItemCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);

        lastRoundStartX = endX;
        lastRoundStartY = endY;
      }

      if (lastCycleLevelCount > rowItemCount + 1) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = startX - shortRowLength;
        endY = startY;

        if (nextLevelController.value > 0) {
          canvas.drawLine(
              Offset(startX, startY),
              Offset(
                lerpDouble(startX, endX + disposition,
                        nextLevelController.value) ??
                    0,
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

    const disposition = 20;

    // Start drawing cycles
    for (int i = 1; i <= rounds; i++) {
      // First Line
      startX = size.width * 0.2;
      startY = roundHeight;

      endX = size.width * 0.8;
      endY = roundHeight;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );

      // First Circle
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
      final tmpOldStartX = startX;
      final tmpOldStartY = startY;

      startX = endX;
      startY = endY + size.height;

      endX = tmpOldStartX;
      endY = tmpOldStartY + size.height;

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint,
      );

      // Second Circle
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

    // Draw last round
    // if only upper row
    if (lastCycleLevelCount <= rowItemCount) {
      double lastCycleStartX = size.width * 0.2;
      double lastCycleStartY = roundHeight;
      final longRowLength = size.width / (rowItemCount + 1);

      // Draw upper lines
      for (int i = 0; i < lastCycleLevelCount; i++) {
        startX = lastCycleStartX;
        startY = lastCycleStartY;

        endX = i == 0 ? longRowLength : startX + longRowLength;
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX - disposition, endY),
          paint,
        );

        lastCycleStartX = endX - disposition;
        lastCycleStartY = endY;
      }
    }
    // If have to move to lower row
    else {
      // Draw upper line
      double upperStartX = size.width * 0.2;
      double upperStartY = roundHeight;

      double upperEndX = size.width * 0.8;
      double upperEndY = upperStartY;

      canvas.drawLine(
        Offset(upperStartX, upperStartY),
        Offset(upperEndX, upperEndY),
        paint,
      );

      // Draw the arc to move down lower row
      centerX = upperEndX;
      centerY = upperEndY + size.height / 2;
      sweepAngle = pi;

      canvas.drawArc(
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      // Draw lower lines
      double lastRoundStartX = centerX;
      double lastRoundStartY = centerY + size.height / 2;
      final shortRowLength = size.width / (rowItemCount + 1);

      for (int i = 0; i < lastCycleLevelCount - rowItemCount; i++) {
        startX = lastRoundStartX;
        startY = lastRoundStartY;

        endX = i == 0 ? rowItemCount * shortRowLength : startX - shortRowLength;
        endY = startY;

        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX + disposition, endY),
          paint,
        );

        lastRoundStartX = endX + disposition;
        lastRoundStartY = endY;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
