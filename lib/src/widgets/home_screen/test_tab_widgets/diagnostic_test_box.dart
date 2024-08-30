import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../flutter_abc_jsc_components.dart';

enum DiagnosticTestBoxStatus { notStarted, inProgress, done }

class DiagnosticTestBoxComponent extends StatelessWidget {
  final String icon;
  final String background;

  final Color color;

  final double progress;
  final bool isDarkMode;

  final DiagnosticTestBoxStatus status;

  final void Function() onClick;

  const DiagnosticTestBoxComponent({
    super.key,
    required this.icon,
    required this.background,
    required this.color,
    required this.onClick,
    required this.progress,
    required this.isDarkMode,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
          child: Text(
            'Diagnostic Test',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        GestureDetector(
          onTap: onClick,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: AssetImage(background),
                  fit: BoxFit.cover,
                ),
                boxShadow: !isDarkMode
                    ? [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 2,
                          spreadRadius: 2,
                          offset: const Offset(0, 1),
                        )
                      ]
                    : null),
            child: Stack(children: [
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: _gradientColors()),
              )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Padding(padding: const EdgeInsets.only(left: 5, right: 20), child: IconWidget(icon: icon, height: 70)),
                          Expanded(
                            child: RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Poppins',
                                ),
                                children: [
                                  TextSpan(text: 'Take our diagnostic test to assess your current level and get a '),
                                  TextSpan(text: 'personalized study plan.', style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    if (status != DiagnosticTestBoxStatus.notStarted)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          percent: progress / 100,
                          animation: true,
                          barRadius: const Radius.circular(20),
                          lineHeight: 8,
                          progressColor: Colors.white,
                          backgroundColor: Colors.grey.shade200.withOpacity(0.3),
                        ),
                      ),
                    if (status == DiagnosticTestBoxStatus.notStarted) const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_getLabel(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                        const Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(Icons.arrow_forward, color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  _gradientColors() => LinearGradient(
      colors: isDarkMode
          ? [
              const Color(0xFF292929).withOpacity(0.55),
              const Color(0xFF292929),
            ]
          : [
              color.withOpacity(0.8),
              color,
            ]);

  _getLabel() {
    switch (status) {
      case DiagnosticTestBoxStatus.notStarted:
        return 'Start diagnostic test';
      case DiagnosticTestBoxStatus.inProgress:
        return 'Continue your test';
      case DiagnosticTestBoxStatus.done:
        return 'See your latest result';
    }
  }
}
