import 'package:flutter/material.dart';

class UpdatedLevel extends StatefulWidget {
  final bool isCurrent;
  final int index;
  final double progress;
  final bool isLock;
  final bool isFreeToday;
  final bool isPlaceholder;
  final bool isFirstTimeOpen;

  const UpdatedLevel(
      {super.key,
      this.isPlaceholder = false,
      required this.progress,
      required this.isCurrent,
      required this.index,
      required this.isLock,
      required this.isFreeToday,
      required this.isFirstTimeOpen});

  @override
  State<UpdatedLevel> createState() => _UpdatedLevelState();
}

class _UpdatedLevelState extends State<UpdatedLevel> with TickerProviderStateMixin {
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
                    child: _mainLevelWidget())),
          )
        else
          AnimatedBuilder(
            animation: _bouncingAnimation,
            builder: (_, __) => Transform.translate(
                offset: Offset(0, _bouncingAnimation.value + 11),
                child: _mainLevelWidget()),
          )
      ],
    );
  }

  Widget _mainLevelWidget() => Column(
        children: [
          SizedBox(
            height: 70,
            width: 65,
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getKetchupColor(),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: widget.isLock
                            ? const Icon(
                                Icons.lock,
                                color: Colors.white,
                              )
                            : Text(
                                '${widget.progress.floor()}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _getValueColor(),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(50)),
                  child: const Icon(
                    Icons.fastfood_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text('Cà chua ${widget.index}')
        ],
      );

  _getKetchupColor() {
    if (widget.isLock) return Colors.green;

    if (widget.progress < 30) {
      return Colors.lightGreen;
    } else if (30 <= widget.progress && widget.progress < 80) {
      return Colors.lime;
    } else {
      return Colors.redAccent;
    }
  }

  _getValueColor() {
    if (30 <= widget.progress && widget.progress < 80) return Colors.grey;
    return Colors.white;
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
      ..color = Colors.green.withOpacity(
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
