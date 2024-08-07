import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../flutter_abc_jsc_components.dart';

class TestList extends StatelessWidget {
  final List<TestData> practiceTests;
  final void Function(int index) onSelect;
  final bool isDarkMode;
  final Color mainColor;
  final Color secondaryColor;

  const TestList({
    super.key,
    required this.practiceTests,
    required this.onSelect,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      width: double.infinity,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 10, bottom: 10),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: practiceTests.length,
          itemBuilder: (_, index) => _testBox(context, practiceTests[index], index)),
    );
  }

  Widget _testBox(BuildContext context, TestData data, int index) => GestureDetector(
        onTap: () => onSelect(data.id),
        child: Container(
          width: MediaQuery.of(context).size.width / 2 - 20,
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(data.background),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: !isDarkMode
                ? [
                    BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: const Offset(0, 1))
                  ]
                : null,
          ),
          child: Stack(children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: (isDarkMode ? const Color(0xFF292929) : secondaryColor)
                    .withOpacity(0.92),
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
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
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: '• ', style: TextStyle(fontSize: 20)),
                          TextSpan(
                              text: data.answeredQuestions.toString(),
                              style: const TextStyle(fontSize: 16)),
                          TextSpan(text: '/${data.totalQuestions} Answered')
                        ]),
                      ),
                    ),
                  ),

                  // Progress
                  Stack(alignment: Alignment.centerRight, children: [
                    LinearPercentIndicator(
                      barRadius: const Radius.circular(15),
                      padding: EdgeInsets.zero,
                      percent: data.progress / 100,
                      progressColor: mainColor,
                      lineHeight: 25,
                      backgroundColor: Colors.white.withOpacity(0.5),
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
                                TextSpan(
                                    text: data.progress.toInt().toString()),
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
          ]),
        ),
      );
}
