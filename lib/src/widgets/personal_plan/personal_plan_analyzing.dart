import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StudyPlanAnalyzingScreen extends StatefulWidget {
  final Color backgroundColor;
  final Color mainColor;
  final String? image;
  final int loadingTime;
  final void Function() onFinish;

  const StudyPlanAnalyzingScreen({
    super.key,
    this.backgroundColor = const Color(0xFFEEFFFA),
    this.mainColor = const Color(0xFF579E89),
    this.image,
    this.loadingTime = 2000,
    required this.onFinish,
  });

  @override
  State<StudyPlanAnalyzingScreen> createState() =>
      _StudyPlanAnalyzingScreenState();
}

class _StudyPlanAnalyzingScreenState extends State<StudyPlanAnalyzingScreen> {
  late ValueNotifier _progressValue;
  late Timer _timer;

  @override
  void initState() {
    _progressValue = ValueNotifier<int>(0);
    _startTimer();
    super.initState();
  }

  void _startTimer() {
    _timer = Timer.periodic(
        Duration(milliseconds: (widget.loadingTime / 100).round()),
        (Timer timer) {
      if (_progressValue.value < 100) {
        _progressValue.value = _progressValue.value + 1;
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _progressValue.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Generating Your Personalized Study Plan...',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: CircleAvatar(
                backgroundColor: widget.mainColor.withOpacity(0.3),
                radius: 140,
                child: CircularPercentIndicator(
                    radius: 120,
                    circularStrokeCap: CircularStrokeCap.round,
                    lineWidth: 20,
                    backgroundColor: widget.mainColor.withOpacity(0.5),
                    progressColor: widget.mainColor,
                    percent: 1,
                    animation: true,
                    animationDuration: widget.loadingTime,
                    onAnimationEnd: () => widget.onFinish(),
                    center: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                          radius: 100,
                          backgroundColor: widget.mainColor.withOpacity(0.3),
                          child: Transform.scale(
                              scale: 1.2,
                              child: Image.asset(widget.image ??
                                  'assets/images/analyzing.png'))),
                    )
                    // image != null ? Image.asset(image!) : null,
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ValueListenableBuilder(
                valueListenable: _progressValue,
                builder: (_, value, __) => Text('$value%',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.mainColor,
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
    );
  }
}
