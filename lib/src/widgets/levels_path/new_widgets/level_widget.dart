import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Level extends StatefulWidget {
  final bool isStarted;
  final int drawSpeed;
  final bool isCurrent;
  final int index;
  final double progress;
  final bool isLock;
  final bool isFreeToday;
  final bool isPlaceholder;
  final bool isFirstTimeOpen;
  final bool isFinalLevel;
  final int rowItemCount;

  const Level(
      {super.key,
      this.isPlaceholder = false,
      required this.progress,
      required this.isCurrent,
      required this.index,
      required this.isLock,
      required this.isFreeToday,
      required this.isFirstTimeOpen,
      required this.drawSpeed,
      required this.isFinalLevel,
      required this.rowItemCount,
      required this.isStarted});

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
        curve: Curves.easeInOut,
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
    int currentIndexIndicatorDelay = widget.index *
        (widget.isFirstTimeOpen ? widget.drawSpeed : widget.drawSpeed ~/ 2);

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
                    child: !widget.isStarted
                        ? widget.index == 0
                            ? _initialLevelWidget()
                            : widget.isFinalLevel ? _finalLevelWidget() : _lockLevelWidget()
                        : widget.isFinalLevel
                            ? _finalLevelWidget()
                            : widget.isCurrent
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
                child: !widget.isStarted
                    ? widget.index == 0
                        ? _initialLevelWidget()
                        : widget.isFinalLevel ? _finalLevelWidget() : _lockLevelWidget()
                    : widget.isFinalLevel
                        ? _finalLevelWidget()
                        : widget.isCurrent
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
            progressColor: _getProgressColor().withOpacity(0.6),
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
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
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
            'Part ${widget.index + 1}',
            style: const TextStyle(
                fontWeight: FontWeight.w600, color: Colors.grey),
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
          'Part ${widget.index + 1}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ]);

  Widget _initialLevelWidget() =>
      Stack(alignment: Alignment.bottomCenter, children: [
        Transform.translate(
            offset: const Offset(0, -100),
            child: Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB443),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text(
                  'Jump Here',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            )),
        Transform.translate(
            offset: const Offset(0, -90),
            child: CustomPaint(
                size: const Size(25, 10),
                painter:
                    DownwardTrianglePainter(color: const Color(0xFFFFB443)))),
        Transform.translate(
          offset: const Offset(0, -25),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFFFFB443).withOpacity(0.5),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white.withOpacity(0.5),
              child: CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFFB443),
                  child: SvgPicture.asset('assets/images/jump_here.svg')),
            ),
          ),
        ),
        Text(
          'Part ${widget.index + 1}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ]);

  Widget _finalLevelWidget() => Stack(alignment: Alignment.center, children: [
        Transform.translate(
          offset: const Offset(0, -70),
          child: Transform.scale(
              scale: 1.2, child: Image.asset('assets/images/final_level.png')),
        ),
        Transform.translate(
          offset: const Offset(0, 25),
          child: Text(
            'Part ${widget.index + 1}',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: widget.isLock ? Colors.grey : null),
          ),
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

class DownwardTrianglePainter extends CustomPainter {
  final Color color;

  DownwardTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    // Define the points for the triangle
    final path = Path()
      ..moveTo(size.width / 2, size.height) // Bottom middle
      ..lineTo(0, 0) // Top left
      ..lineTo(size.width, 0) // Top right
      ..close(); // Complete the triangle

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill; // Fill the triangle

    // Draw the triangle on the canvas
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if there's no change
  }
}
