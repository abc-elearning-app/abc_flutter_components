import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'path_animation.dart';

class LevelWidget extends StatefulWidget {
  final String title;
  final bool isCurrent;
  final int index;
  final double progress;
  final bool isLock;
  final bool isFreeToday;
  final bool isPlaceholder;
  final bool isFirstTimeOpen;
  final bool isFinal;
  final DrawType drawType;
  final Duration drawSpeed;

  const LevelWidget(
      {super.key,
      this.isPlaceholder = false,
      required this.title,
      required this.progress,
      required this.isCurrent,
      required this.index,
      required this.isLock,
      required this.isFreeToday,
      required this.isFirstTimeOpen,
      required this.isFinal,
      required this.drawType,
      required this.drawSpeed});

  @override
  State<LevelWidget> createState() => _LevelWidgetState();
}

class _LevelWidgetState extends State<LevelWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadingInAnimation;
  late Animation<double> _landingAnimation;
  late Animation<double> _bouncingAnimation;

  late AnimationController _splashController;

  @override
  void initState() {
    _init();
    _startAnimation();
    super.initState();
  }

  _init() {
    // Initialize controller and animations (if exist)
    if (widget.drawType != DrawType.noAnimation) {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      );

      // Fading and bouncing animation on first time open
      if (widget.drawType == DrawType.firstTimeOpen) {
        _fadingInAnimation = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );

        // Offset y 20 is default to match the line
        _landingAnimation = Tween<double>(begin: -25, end: 0).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        );
      } else {
        // Bounce animation of next level
        _bouncingAnimation = Tween<double>(
          begin: 0,
          end: -20,
        ).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.bounceIn,
          ),
        );
      }
    }

    // Splash controller for current level
    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  _startAnimation() {
    // Delay appearance of level widgets
    final delayTime = widget.index * widget.drawSpeed.inMilliseconds;

    // Start animation
    switch (widget.drawType) {
      case DrawType.firstTimeOpen:
        Future.delayed(
            Duration(milliseconds: delayTime), () => _controller.forward());
        break;
      case DrawType.nextLevel:
        if (widget.isCurrent) {
          _controller.addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _controller.reverse();
            }
          });

          Future.delayed(
              Duration(milliseconds: widget.drawSpeed.inMilliseconds + 900),
              () => _controller.forward());
        }
        break;
      case DrawType.noAnimation:
        break;
    }

    // Start splash animation
    if (widget.isCurrent) {
      _splashController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _splashController.forward(from: 0);
        }
      });

      Future.delayed(
          Duration(
              milliseconds: widget.drawType != DrawType.noAnimation
                  ? delayTime + 1000
                  : 0),
          () => _splashController.forward());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _splashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Splash animation
        if (widget.isCurrent)
          CustomPaint(
              size: const Size(20, 20),
              painter: SplashCirclePainter(animation: _splashController)),

        // Level
        _levelWidget()
      ],
    );
  }

  _levelWidget() {
    switch (widget.drawType) {
      case DrawType.firstTimeOpen:
        return AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Opacity(
                opacity: _fadingInAnimation.value,
                child: Transform.translate(
                    offset: Offset(0, _landingAnimation.value),
                    child: _buildLevelWidget())));
      case DrawType.nextLevel:
        return widget.isCurrent
            ? AnimatedBuilder(
                animation: _bouncingAnimation,
                builder: (_, __) => Transform.translate(
                    offset: Offset(0, _bouncingAnimation.value),
                    child: _buildLevelWidget()),
              )
            : _buildLevelWidget();
      default:
        return _buildLevelWidget();
    }
  }

  Widget _buildLevelWidget() => Transform.translate(
        offset: const Offset(0, 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            widget.isFinal ? _finalLevel() : _regularLevel(),

            // Title
            Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      );

  Widget _regularLevel() => Stack(
        alignment: Alignment.topRight,
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: _getMainColor().withOpacity(0.2),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 30,
                backgroundColor: _getMainColor(),
                child: SvgPicture.asset(
                  'assets/images/topic_icon_${widget.index % 3}.svg',
                  colorFilter:
                      ColorFilter.mode(_getIconColor(), BlendMode.srcIn),
                ),
              ),
            ),
          ),

          // Lock icon if locked
          if (widget.isLock)
            Transform.translate(
                offset: const Offset(-5, 5),
                child: const Icon(Icons.lock, color: Colors.grey))
        ],
      );

  Widget _finalLevel() => Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Image.asset(
          'assets/images/final_cup.png',
          scale: 0.8,
        ),
      );

  _getMainColor() {
    if (widget.isLock) return const Color(0xFFF3F2F2);
    if (widget.isCurrent) {
      if (widget.progress > 0 && widget.progress < 20) {
        return const Color(0xFFFC5656);
      }
      return const Color(0xFFE3A651);
    }
    return const Color(0xFF3CC079);
  }

  _getIconColor() => widget.isLock ? Colors.grey : Colors.white;
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
