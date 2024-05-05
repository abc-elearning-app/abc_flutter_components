import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Level extends StatefulWidget {
  final bool isCurrent;
  final int index;
  final double progress;
  final bool isLock;
  final bool isFreeToday;
  final bool isPlaceholder;
  final bool isFirstTimeOpen;

  const Level(
      {super.key,
      this.isPlaceholder = false,
      required this.progress,
      required this.isCurrent,
      required this.index,
      required this.isLock,
      required this.isFreeToday,
      required this.isFirstTimeOpen});

  @override
  State<Level> createState() => _LevelState();
}

class _LevelState extends State<Level> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadingInAnimation;
  late Animation<double> _landingAnimation;
  late Animation<double> _bouncingAnimation;

  late AnimationController _splashController;

  bool _animationStarted = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadingInAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _landingAnimation = Tween(begin: -10.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve:
            Curves.easeInOut, // Adjust the curve for different movement effect
      ),
    );

    _splashController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Adjust the duration of one cycle
    );

    _bouncingAnimation = Tween<double>(
      begin: 10,
      end: -8,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceIn,
      ),
    );

    // Delay appearance of level widgets
    final currentIndexIndicatorDelay =
        widget.index * (widget.isFirstTimeOpen ? 200 : 100);

    if (widget.isFirstTimeOpen) {
      Future.delayed(Duration(milliseconds: currentIndexIndicatorDelay), () {
        _controller.forward();
      });
    } else {
      //TODO: setup next level animation
      if (widget.isCurrent) {
        _controller.addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _controller.reverse();
          }
          // Repeat the bouncing effect
          // else if (status == AnimationStatus.dismissed) {
          //   Future.delayed(const Duration(seconds: 1), () => _controller.forward());
          // }
        });

        Future.delayed(Duration(milliseconds: currentIndexIndicatorDelay),
            () => _controller.forward());
      }
    }

    // Start splash animation
    if (widget.isCurrent) {
      // _splashController.forward();
      Future.delayed(Duration(milliseconds: currentIndexIndicatorDelay + 1000),
          () {
        startSplashAnimation();
        setState(() {
          _animationStarted = true;
        });
      });
    }
  }

  void startSplashAnimation() {
    _splashController.forward().then((_) {
      _splashController.reset(); // Reset the animation to its initial state
      startSplashAnimation(); // Start the animation again
    });
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
        if (widget.isCurrent)
          Transform.translate(
            offset: const Offset(0, -5),
            child: CustomPaint(
              size: const Size(20.0, 20.0),
              painter: SplashCirclePainter(
                  animation: _splashController,
                  animationStarted: _animationStarted),
            ),
          ),
        if (widget.isFirstTimeOpen)
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) => Opacity(
                opacity: _fadingInAnimation.value,
                child: Transform.translate(
                    offset: Offset(0, _landingAnimation.value + 20),
                    child: widget.isCurrent
                        ? _currentLevelWidget()
                        : widget.isLock
                            ? _lockLevelWidget()
                            : _mainLevelWidget())),
          )
        else
          AnimatedBuilder(
            animation: _bouncingAnimation,
            builder: (_, __) => Transform.translate(
                offset: Offset(0, _bouncingAnimation.value + 11),
                child: widget.isCurrent
                    ? _currentLevelWidget()
                    : widget.isLock
                        ? _lockLevelWidget()
                        : _mainLevelWidget()),
          )
      ],
    );
  }

  Widget _mainLevelWidget() =>
      Stack(alignment: Alignment.bottomCenter, children: [
        Transform.translate(
          offset: const Offset(0, -25),
          child: CircularPercentIndicator(
            radius: 35,
            lineWidth: 7,
            backgroundColor: _getProgressColor().withOpacity(0.2),
            progressColor: _getProgressColor(),
            percent: widget.progress / 100,
            circularStrokeCap: CircularStrokeCap.round,
            center: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 25,
                backgroundColor: _getProgressColor(),
                child: Text(
                  '${widget.progress.toInt()}%',
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ),
        ),
        Text(
          'Part ${widget.index}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ]);

  Widget _lockLevelWidget() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Transform.translate(
            offset: const Offset(0, -25),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade200,
              child: const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.lock,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Text(
            'Part ${widget.index}',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      );

  Widget _currentLevelWidget() =>
      Stack(alignment: Alignment.bottomCenter, children: [
        Transform.translate(
          offset: const Offset(0, -25),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: _getProgressColor(value: 100).withOpacity(0.5),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.5),
              child: CircleAvatar(
                  radius: 24,
                  backgroundColor: _getProgressColor(value: 100),
                  child: SvgPicture.asset('assets/images/play.svg')),
            ),
          ),
        ),
        Text(
          'Part ${widget.index}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ]);

  Color _getProgressColor({double? value}) {
    if (widget.isLock) return Colors.grey;

    final progress = value ?? widget.progress;
    if (progress < 40) {
      return const Color(0xFFFC5656);
    } else {
      return const Color(0xFF579E89);
    }
  }
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
  final bool animationStarted;

  SplashCirclePainter({required this.animation, required this.animationStarted})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    double maxRadius = 30;

    Paint paint = Paint()
      ..color = Colors.grey.withOpacity(
          1 * (1 - animation.value)) // Adjust opacity based on animation value
      ..style = PaintingStyle.stroke
      ..strokeWidth = 50;

    double currentRadius = maxRadius * animation.value;

    if (animationStarted) {
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
