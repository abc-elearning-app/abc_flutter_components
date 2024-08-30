import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../flutter_abc_jsc_components.dart';

class TestData {
  final int id;
  final String title;
  final int answeredQuestions;
  final int totalQuestions;
  final int correctQuestions;
  final double progress;
  final double correct;
  final bool isDone;
  final String background;
  final double passingPercent;

  TestData({
    required this.id,
    required this.title,
    required this.answeredQuestions,
    required this.totalQuestions,
    required this.correctQuestions,
    required this.progress,
    required this.background,
    required this.correct,
    required this.isDone,
    required this.passingPercent,
  });
}

class TestBox extends StatelessWidget {
  final int index;
  final TestData data;
  final void Function(int index) onSelect;

  final bool isDarkMode;
  final double minPassPercent;

  final Color mainColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color secondaryColor;

  final String correctIcon;
  final String incorrectIcon;

  const TestBox({
    super.key,
    required this.index,
    required this.data,
    required this.onSelect,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.mainColor,
    required this.correctColor,
    required this.incorrectColor,
    required this.minPassPercent,
    required this.correctIcon,
    required this.incorrectIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(data.id),
      child: Container(
        width: 175,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(data.background),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 1, spreadRadius: 1, offset: const Offset(0, 1))] : null,
        ),
        child: Stack(children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: isDarkMode
                    ? [const Color(0xFF292929).withOpacity(0.8), Colors.grey.shade900]
                    : [
                        Colors.transparent,
                        secondaryColor.withOpacity(0.5),
                        secondaryColor,
                      ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: isDarkMode ? const [0, 0.8] : const [0, 0.2, 0.5],
              ),
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Practice Test ${index + 1}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),

                // Questions
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: RichText(
                      text: TextSpan(style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400), children: [
                        TextSpan(text: '• ${data.isDone ? data.correctQuestions : data.answeredQuestions}'),
                        TextSpan(
                          text: '/${data.totalQuestions} ${data.isDone ? 'Correct' : 'Answered'}',
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                      ]),
                    )),

                // Progress
                Stack(alignment: Alignment.centerRight, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      percent: (data.isDone ? data.correct : data.progress) / 100,
                      progressColor: data.isDone
                          ? data.correct < minPassPercent
                              ? incorrectColor
                              : correctColor
                          : mainColor,
                      lineHeight: 25,
                      backgroundColor: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: RichText(
                        text: TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            children: [
                              TextSpan(text: (data.isDone ? data.correct : data.progress).toInt().toString()),
                              const TextSpan(
                                  text: '%',
                                  style: TextStyle(
                                    fontSize: 12,
                                  ))
                            ]),
                      ))
                ])
              ],
            ),
          ),

          if (data.isDone)
            Positioned(
              top: 10,
              right: 10,
              child: IconWidget(icon: data.correct < minPassPercent ? incorrectIcon : correctIcon, height: 30,),
            )
        ]),
      ),
    );
  }
}
