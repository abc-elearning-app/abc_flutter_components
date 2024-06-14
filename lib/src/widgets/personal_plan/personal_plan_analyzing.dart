import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FloatingTextData {
  final int initX;
  final int initY;
  final String text;

  FloatingTextData(this.initX, this.initY, this.text);
}

class PersonalPlanAnalyzingScreen extends StatefulWidget {
  final Color backgroundColor;
  final Color mainColor;
  final Color secondaryColor;
  final String? loadingImage;
  final String? finishImage;
  final int loadingTime;
  final int floatingTextAnimationTime;
  final TextStyle? floatingTextStyle;
  final bool isDarkMode;
  final void Function() onFinish;

  const PersonalPlanAnalyzingScreen({
    super.key,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.mainColor = const Color(0xFF7C6F5B),
    this.secondaryColor = const Color(0xFFE5E2CB),
    this.loadingImage,
    this.finishImage,
    this.loadingTime = 2000,
    this.floatingTextAnimationTime = 1500,
    this.floatingTextStyle,
    required this.onFinish,
    required this.isDarkMode,
  });

  @override
  State<PersonalPlanAnalyzingScreen> createState() =>
      _PersonalPlanAnalyzingScreenState();
}

class _PersonalPlanAnalyzingScreenState
    extends State<PersonalPlanAnalyzingScreen> with TickerProviderStateMixin {
  final _progressValue = ValueNotifier<int>(0);
  late Timer _timer;

  late List<AnimationController> _animControllers;
  final List<Animation<double>> _animations = [];

  final floatingTextList = [
    FloatingTextData(80, -80, 'Diagnostic Test'),
    FloatingTextData(-80, -80, 'Exam Date'),
    FloatingTextData(-80, 80, 'Reminders'),
  ];

  @override
  void initState() {
    _startLoading();
    _startFloatingTextAnimation();

    super.initState();
  }

  _startLoading() {
    _timer = Timer.periodic(
        Duration(milliseconds: (widget.loadingTime / 100).round()), (_) {
      if (_progressValue.value < 100) {
        _progressValue.value++;
      } else {
        _timer.cancel();
      }
    });
  }

  _startFloatingTextAnimation() {
    // 3 animation controllers for 3 text
    _animControllers = List.generate(
        3,
        (_) => AnimationController(
            vsync: this,
            duration:
                Duration(milliseconds: widget.floatingTextAnimationTime)));

    int startTime = 0;
    for (AnimationController animController in _animControllers) {
      // Add corresponding animation
      _animations.add(Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeInOut)));

      // Repeat when finish
      animController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1),
              () => animController.forward(from: 0));
        }
      });

      // Start sequentially
      Future.delayed(
          Duration(milliseconds: startTime), () => animController.forward());

      startTime += 800;
    }
  }

  @override
  void dispose() {
    _progressValue.dispose();
    _timer.cancel();

    for (AnimationController animController in _animControllers) {
      animController.removeStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1),
              () => animController.forward(from: 0));
        }
      });

      animController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Colors.black : widget.backgroundColor,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Generating Your Personalized Study Plan...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: widget.isDarkMode ? Colors.white : Colors.black),
                ),
              ),

              _buildCircularLoadingProgress(),

              // Progress number
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: ValueListenableBuilder(
                  valueListenable: _progressValue,
                  builder: (_, value, __) => Text('$value%',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.isDarkMode
                              ? Colors.white
                              : widget.mainColor,
                          fontSize: 40)),
                ),
              ),

              const Text(
                'Analyzing Your Data ...',
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularLoadingProgress() {
    const double outerRadius = 135;
    const double lineWidth = 18;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Stack(children: [
        const CircleAvatar(radius: outerRadius, backgroundColor: Colors.white),
        CircleAvatar(
          backgroundColor: widget.secondaryColor,
          radius: outerRadius,
          child: CircularPercentIndicator(
              radius: outerRadius - lineWidth,
              circularStrokeCap: CircularStrokeCap.round,
              lineWidth: lineWidth,
              backgroundColor: widget.mainColor.withOpacity(0.4),
              progressColor: widget.mainColor,
              percent: 1,
              animation: true,
              animationDuration: widget.loadingTime,
              onAnimationEnd: () => Future.delayed(
                  const Duration(milliseconds: 300), () => widget.onFinish()),
              center: CircleAvatar(
                  radius: outerRadius - 2 * lineWidth,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Image icon
                      ValueListenableBuilder(
                          valueListenable: _progressValue,
                          builder: (_, value, __) =>
                              Image.asset(_getImagePath(value))),

                      // Floating texts
                      _floatingTexts(),
                    ],
                  ))),
        ),
      ]),
    );
  }

  Widget _floatingTexts() => Stack(
          children: List.generate(
        3,
        (index) => AnimatedBuilder(
          animation: _animations[index],
          builder: (_, __) => Transform.translate(
            offset: Offset(
              _calculateOffsetX(index),
              _calculateOffsetY(index),
            ),
            child: Transform.scale(
              scale: 1 - _animations[index].value,
              child: Opacity(
                opacity: _calculateFadeOpacity(index),
                child: Text(floatingTextList[index].text,
                    style: widget.floatingTextStyle ??
                        TextStyle(
                            color: widget.isDarkMode
                                ? Color.lerp(Colors.white, Colors.black,
                                    _animations[index].value)
                                : Colors.black,
                            fontSize: 20)),
              ),
            ),
          ),
        ),
      ));

  String _getImagePath(int value) => value < 100
      ? widget.loadingImage ?? 'assets/images/analyzing.png'
      : widget.finishImage ?? 'assets/images/analyzing_done.png';

  double _calculateOffsetX(int index) =>
      floatingTextList[index].initX * (1 - _animations[index].value);

  double _calculateOffsetY(int index) =>
      floatingTextList[index].initY * (1 - _animations[index].value) -
      50; // Move up to match the figure's head

  double _calculateFadeOpacity(int index) => _animations[index].value <= 0.5
      ? (_animations[index].value * 20).clamp(0, 1)
      : 2 - _animations[index].value * 2;
}
