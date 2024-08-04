import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FinalTestBox extends StatelessWidget {
  final String icon;
  final String background;

  final Color mainColor;
  final Color secondaryColor;

  final double progress;
  final int answeredQuestions;
  final int totalQuestions;
  final double correctPercent;
  final bool isDarkMode;
  final List<Color> gradientColors;

  final void Function() onClickFinal;

  const FinalTestBox({
    super.key,
    required this.icon,
    required this.background,
    required this.mainColor,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.correctPercent,
    required this.progress,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.onClickFinal,
    this.gradientColors = const [
      Color(0xFFC0A67C),
      Color(0xFF958366),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickFinal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.cover,
            ),
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2, offset: const Offset(0, 1))] : null,
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: _gradientColors()),
          )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 20),
                      child: IconWidget(icon: icon, height: 80),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Final Test', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          Text('Our final test is the ultimate gauge that assesses your readiness for the actual exam.',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white)),
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    percent: progress / 100,
                    animation: true,
                    barRadius: const Radius.circular(20),
                    lineHeight: 10,
                    progressColor: mainColor,
                    backgroundColor: Colors.grey.shade200.withOpacity(0.3),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                        text: TextSpan(style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400), children: [
                      TextSpan(text: answeredQuestions.toString()),
                      TextSpan(text: '/$totalQuestions Answered', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)))
                    ])),
                    Text(
                      '${correctPercent.toInt()}% Correct',
                      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
                    )
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _gradientColors() => LinearGradient(
      colors: isDarkMode
          ? [
              const Color(0xFF292929).withOpacity(0.8),
              const Color(0xFF292929),
            ]
          : [
              gradientColors[0].withOpacity(0.8),
              gradientColors[1],
            ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
