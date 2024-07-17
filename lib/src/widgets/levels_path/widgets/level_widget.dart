import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class LevelWidget extends StatefulWidget {
  final int index;
  final LevelData levelData;
  final bool isPlaceholder;
  final bool isFinal;
  final DrawType drawType;
  final Duration drawSpeed;
  final String finalLevelImage;
  final bool isFirstGroup;
  final bool isDarkMode;

  final Color startColor;
  final Color passColor;
  final Color mainColor;
  final Color lockColor;

  final void Function(String id) onClickLevel;

  const LevelWidget({
    super.key,
    this.isPlaceholder = false,
    required this.levelData,
    required this.isFinal,
    required this.drawType,
    required this.drawSpeed,
    required this.index,
    required this.startColor,
    required this.finalLevelImage,
    required this.isFirstGroup,
    required this.passColor,
    required this.mainColor,
    required this.lockColor,
    required this.onClickLevel,
    required this.isDarkMode,
  });

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _appearanceController;

  late AnimationController _splashController;

  // late AnimationController _tooltipController;

  // Animations
  late Animation<double> _tooltipAnimation;
  late Animation<double> _fadingInAnimation;
  late Animation<double> _landingAnimation;
  late Animation<double> _scalingAnimation;

  @override
  void initState() {
    _initAnimation();
    _startAnimation();
    super.initState();
  }

  _initAnimation() {
    /// Animations when appear
    _appearanceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.drawType == DrawType.nextLevel) {
      _appearanceController.addStatusListener(reverseListener);
    }

    _fadingInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.easeInOut,
      ),
    );

    _landingAnimation = Tween<double>(begin: 0, end: 25).animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.easeInOut,
      ),
    );

    _scalingAnimation = Tween<double>(
            begin: 1,
            end: widget.drawType == DrawType.nextLevel &&
                    widget.levelData.isCurrent
                ? 1.15
                : 1)
        .animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.easeInOut,
      ),
    );

    /// Animations on current level
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _splashController.addStatusListener(forwardSplashListener);

    // _tooltipController = AnimationController(
    //     vsync: this, duration: const Duration(milliseconds: 500));
    //
    // _tooltipAnimation =
    //     Tween<double>(begin: -15, end: -10).animate(_tooltipController);
    //
    // _tooltipController.addStatusListener(tooltipListener);
  }

  // void tooltipListener(status) {
  //   if (status == AnimationStatus.completed) {
  //     _tooltipController.reverse();
  //   } else if (status == AnimationStatus.dismissed) {
  //     _tooltipController.forward();
  //   }
  // }

  void forwardSplashListener(status) {
    if (status == AnimationStatus.completed) {
      _splashController.forward(from: 0);
    }
  }

  void reverseListener(status) {
    if (status == AnimationStatus.completed) {
      Future.delayed(const Duration(microseconds: 300), () {
        if (mounted) {
          _appearanceController.reverse();
        }
      });
    }
  }

  _startAnimation() {
    /// Start appearance animation
    final delayTime = widget.index * widget.drawSpeed.inMilliseconds;
    switch (widget.drawType) {
      case DrawType.firstTimeOpen:
        Future.delayed(Duration(milliseconds: delayTime), () {
          if (mounted) {
            _appearanceController.forward();
          }
        });
        break;
      case DrawType.nextLevel:
        if (widget.levelData.isCurrent) {
          Future.delayed(
              Duration(milliseconds: widget.drawSpeed.inMilliseconds + 1200),
              () {
            if (mounted) {
              _appearanceController.forward();
            }
          });
        }
        break;
      case DrawType.noAnimation:
        break;
    }

    /// Start current level animation
    if (widget.levelData.isCurrent) {
      Future.delayed(
          Duration(
              milliseconds: widget.drawType != DrawType.noAnimation
                  ? delayTime + 1000
                  : 0), () {
        if (mounted) {
          _splashController.forward();
        }
      });
    }

    // Start tooltip animation
    // if (widget.index == 0 && widget.levelData.progress == 0) {
    // _tooltipController.forward();
    // }
  }

  double outerRadius = 35;
  double circleWidth = 5;

  @override
  void dispose() {
    _appearanceController.removeStatusListener(reverseListener);
    _appearanceController.dispose();

    _splashController.removeStatusListener(forwardSplashListener);
    _splashController.dispose();

    // _tooltipController.removeStatusListener(tooltipListener);
    // _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Splash animation
        if (widget.levelData.isCurrent && !widget.isFinal
            // && (widget.index != 0 || widget.levelData.progress != 0)
            )
          CustomPaint(
              size: const Size(20, 20),
              painter: SplashCirclePainter(
                animation: _splashController,
                color: widget.mainColor,
              )),

        // Level
        AnimatedBuilder(
            animation: _appearanceController,
            builder: (_, __) => Opacity(
                  opacity: _getOpacityValue(),
                  child: Stack(alignment: Alignment.center, children: [
                    Transform.translate(
                        offset: Offset(0, _getTranslateValue()),
                        child: GestureDetector(
                          onTap: () => !widget.levelData.isLock
                              ? widget.onClickLevel(widget.levelData.id)
                              : null,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Regular level or final cup
                              Transform.scale(
                                  scale: _scalingAnimation.value,
                                  child: _getLevelWidget()),

                              // Title
                              SizedBox(
                                width: 120,
                                child: Text(widget.levelData.title,
                                    textAlign: TextAlign.center,
                                    maxLines: 3,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              )
                            ],
                          ),
                        )),
                    // if (widget.levelData.isCurrent) _tooltip()
                  ]),
                )),

        // Tooltip animation
        // if (widget.levelData.isCurrent
        // &&
        // (widget.index == 0 && widget.levelData.progress == 0)
        // )
        // _tooltip(),
      ],
    );
  }

  Widget _getLevelWidget() {
    // if (widget.isFinal) return _finalLevel();
    if (widget.levelData.isLock) return _lockLevel();
    return _defaultLevel();
  }

  Widget _defaultLevel() => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: !widget.isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 1,
                        spreadRadius: 1)
                  ]
                : null),
        child: CircleAvatar(
          radius: outerRadius,
          backgroundColor: Color.lerp(_getMainColor(), Colors.white, 0.4),
          child: CircleAvatar(
            radius: outerRadius - circleWidth,
            backgroundColor: Colors.white,
            child: CircleAvatar(
                radius: outerRadius - circleWidth - 4,
                backgroundColor: _getMainColor(),
                child: widget.levelData.progress == 100
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 30,
                      )
                    : widget.levelData.progress == 0
                        ? IconWidget(
                            icon: widget.levelData.icon,
                            height: outerRadius,
                            color: _getIconColor(),
                          )
                        : Text(
                            '${widget.levelData.progress.toInt()}%',
                            style: const TextStyle(color: Colors.white),
                          )),
          ),
        ),
      );

  Widget _lockLevel() => Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 1,
                      spreadRadius: 1)
                ]),
            child: CircleAvatar(
              radius: outerRadius,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: outerRadius - circleWidth - 2,
                backgroundColor: Colors.grey.shade100,
                child: SvgPicture.asset(
                  widget.levelData.icon,
                  height: outerRadius,
                  color: _getIconColor(),
                ),
              ),
            ),
          ),

          // Lock icon
          Transform.translate(
              offset: const Offset(3, -3),
              child: const Icon(Icons.lock, color: Color(0xFFDADADA)))
        ],
      );

  Widget _finalLevel() => Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Opacity(
        opacity: widget.levelData.isCurrent ? 1 : 0.6,
        child: Image.asset(
          widget.finalLevelImage,
          scale: 0.8,
          width: 65,
        ),
      ));

  // Widget _tooltip() => AnimatedBuilder(
  //       animation: _tooltipAnimation,
  //       builder: (_, __) => Transform.translate(
  //         offset: Offset(0, _tooltipAnimation.value),
  //         child: Stack(children: [
  //           Column(
  //             children: [
  //               // Tooltip is a rectangle with a triangle below
  //               Container(
  //                   padding:
  //                       const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
  //                   decoration: BoxDecoration(
  //                       // image: widget.isFirstGroup
  //                       //     ? const DecorationImage(
  //                       //         image:
  //                       //             AssetImage('assets/static/images/level_start.gif'),
  //                       //         fit: BoxFit.cover)
  //                       //     : null,
  //                       color: widget.mainColor,
  //                       borderRadius: BorderRadius.circular(10),
  //                       border: Border.all(color: Colors.white, width: 1),
  //                       boxShadow: !widget.isDarkMode
  //                           ? [
  //                               BoxShadow(
  //                                   color: Colors.grey.shade300,
  //                                   blurRadius: 5,
  //                                   spreadRadius: 2,
  //                                   offset: const Offset(2, 2))
  //                             ]
  //                           : null),
  //                   child: const Center(
  //                     child: Text('Start',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w500,
  //                         )),
  //                   )),
  //               Transform.translate(
  //                 offset: const Offset(0, -1),
  //                 child: CustomPaint(
  //                     size: const Size(20, 20),
  //                     painter: DownwardTrianglePainter(
  //                         mainColor: widget.mainColor,
  //                         borderColor: Colors.white,
  //                         borderWidth: 1)),
  //               )
  //             ],
  //           ),
  //         ]),
  //       ),
  //     );

  _getOpacityValue() => widget.drawType == DrawType.firstTimeOpen
      ? _fadingInAnimation.value
      : 1.0;

  _getTranslateValue() => widget.drawType == DrawType.firstTimeOpen
      ? _landingAnimation.value
      : 25.0;

  _getMainColor() {
    if (widget.levelData.isLock) return widget.lockColor;

    if (widget.index == 0 && widget.levelData.progress == 0) {
      return widget.startColor;
    }

    if (widget.levelData.isCurrent) return widget.mainColor;

    return widget.passColor;
  }

  _getIconColor() => widget.levelData.isLock ? Colors.grey : Colors.white;
}

class PlaceholderLevel extends StatelessWidget {
  const PlaceholderLevel({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(width: 65);
  }
}

class SplashCirclePainter extends CustomPainter {
  final Color color;
  final Animation<double> animation;

  SplashCirclePainter({
    required this.animation,
    required this.color,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double maxRadius = 30;

    Paint paint = Paint()
      ..color = color.withOpacity(1 * (1 - animation.value))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 60;

    double currentRadius = maxRadius * animation.value;

    if (animation.value > 0) {
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        currentRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class DownwardTrianglePainter extends CustomPainter {
  final Color mainColor;
  final Color borderColor;
  final double borderWidth;

  DownwardTrianglePainter({
    required this.mainColor,
    required this.borderColor,
    this.borderWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Paint object for the filled triangle
    final fillPaint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    // Path for the triangle
    final path = Path()
      ..moveTo(size.width / 2, size.height / 3) // Bottom center
      ..lineTo(0, 0) // Top left
      ..lineTo(size.width, 0) // Top right
      ..close();

    // Draw the filled triangle
    canvas.drawPath(path, fillPaint);

    // Paint object for the border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Draw the border lines manually, excluding the top edge
    canvas.drawLine(Offset(size.width / 2, size.height / 3), Offset(0, 0),
        borderPaint); // Left edge
    canvas.drawLine(Offset(size.width / 2, size.height / 3),
        Offset(size.width, 0), borderPaint); // Right edge
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
