import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LevelWidget extends StatefulWidget {
  final int index;
  final LevelData levelData;
  final bool isPlaceholder;
  final bool isFinal;
  final DrawType drawType;
  final Duration drawSpeed;
  final Color startColor;
  final String finalLevelImage;

  const LevelWidget(
      {super.key,
      required this.levelData,
      this.isPlaceholder = false,
      required this.isFinal,
      required this.drawType,
      required this.drawSpeed,
      required this.index,
      required this.startColor,
      required this.finalLevelImage});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget>
    with TickerProviderStateMixin {
  // Controllers
  late AnimationController _appearanceController;
  late AnimationController _splashController;
  late AnimationController _tooltipController;

  // Animations
  late Animation<double> _tooltipAnimation;
  late Animation<double> _fadingInAnimation;
  late Animation<double> _landingAnimation;
  late Animation<double> _bouncingAnimation;

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
      duration: const Duration(milliseconds: 300),
    );

    if (widget.drawType == DrawType.nextLevel) {
      _appearanceController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _appearanceController.reverse();
        }
      });
    }

    _fadingInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.easeInOut,
      ),
    );

    _landingAnimation = Tween<double>(begin: -25, end: 0).animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.easeInOut,
      ),
    );

    _bouncingAnimation = Tween<double>(
      begin: 0,
      end: -20,
    ).animate(
      CurvedAnimation(
        parent: _appearanceController,
        curve: Curves.bounceIn,
      ),
    );

    /// Animations on current level
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _splashController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _splashController.forward(from: 0);
      }
    });

    _tooltipController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _tooltipAnimation =
        Tween<double>(begin: -40, end: -30).animate(_tooltipController);

    _tooltipController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _tooltipController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        _tooltipController.forward();
      }
    });
  }

  _startAnimation() {
    /// Start appearance animation
    final delayTime = widget.index * widget.drawSpeed.inMilliseconds;
    switch (widget.drawType) {
      case DrawType.firstTimeOpen:
        Future.delayed(Duration(milliseconds: delayTime),
            () => _appearanceController.forward());
        break;
      case DrawType.nextLevel:
        if (widget.levelData.isCurrent) {
          Future.delayed(
              Duration(milliseconds: widget.drawSpeed.inMilliseconds + 900),
              () => _appearanceController.forward());
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
                  : 0),
          () => _splashController.forward());
    }

    // Start tooltip animation
    if (widget.index == 0 && widget.levelData.progress == 0) {
      _tooltipController.forward();
    }
  }

  @override
  void dispose() {
    _appearanceController.dispose();
    _splashController.dispose();
    _tooltipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Splash animation or tooltip animation
        if (widget.levelData.isCurrent)
          widget.index == 0 && widget.levelData.progress == 0
              ? _buildTooltip()
              : CustomPaint(
                  size: const Size(20, 20),
                  painter: SplashCirclePainter(animation: _splashController)),

        // Level
        AnimatedBuilder(
            animation: _appearanceController,
            builder: (_, __) => Opacity(
                  opacity: _getOpacityValue(),
                  child: Transform.translate(
                      offset: Offset(0, _getTranslateValue()),
                      child: Stack(alignment: Alignment.topCenter, children: [
                        Transform.translate(
                          offset: const Offset(0, 18),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // Regular level or final cup
                              widget.isFinal ? _finalLevel() : _mainLevel(),

                              // Title
                              Text(
                                widget.levelData.title,
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ),
                        ),
                      ])),
                ))
      ],
    );
  }

  Widget _mainLevel() => Stack(
        alignment: Alignment.topRight,
        children: [
          CircleAvatar(
            radius: 42,
            backgroundColor: _getMainColor().withOpacity(0.2),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _getMainColor(),
                child: SvgPicture.asset(
                  widget.levelData.icon,
                  colorFilter:
                      ColorFilter.mode(_getIconColor(), BlendMode.srcIn),
                ),
              ),
            ),
          ),

          // Lock icon if locked
          if (widget.levelData.isLock)
            Transform.translate(
                offset: const Offset(-5, 5),
                child: const Icon(Icons.lock, color: Colors.grey))
        ],
      );

  Widget _finalLevel() => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Image.asset(widget.finalLevelImage, scale: 0.8));

  Widget _buildTooltip() => AnimatedBuilder(
        animation: _tooltipAnimation,
        builder: (_, __) => Transform.translate(
          offset: Offset(0, _tooltipAnimation.value),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                    color: widget.startColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 5,
                          spreadRadius: 2,
                          offset: const Offset(2, 2))
                    ]),
                child: const Text('Jump Here',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    )),
              ),
              CustomPaint(
                size: const Size(20, 20),
                painter: DownwardTrianglePainter(widget.startColor),
              )
            ],
          ),
        ),
      );

  _getOpacityValue() => widget.drawType == DrawType.firstTimeOpen
      ? _fadingInAnimation.value
      : 1.0;

  _getTranslateValue() => widget.drawType == DrawType.firstTimeOpen
      ? _landingAnimation.value
      : _bouncingAnimation.value;

  _getMainColor() {
    if (widget.levelData.isLock) return const Color(0xFFF3F2F2);
    if (widget.levelData.isCurrent) {
      if (widget.levelData.progress > 0 && widget.levelData.progress < 20) {
        return const Color(0xFFFC5656);
      }
      return const Color(0xFFE3A651);
    }
    return const Color(0xFF3CC079);
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
  final Animation<double> animation;

  SplashCirclePainter({required this.animation}) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double maxRadius = 30;

    Paint paint = Paint()
      ..color = const Color(0xFFE3A651).withOpacity(1 * (1 - animation.value))
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

  DownwardTrianglePainter(this.mainColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = mainColor
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height / 3) // Bottom center
      ..lineTo(0, 0) // Top left
      ..lineTo(size.width, 0) // Top right
      ..close();

    // Draw the triangle
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
