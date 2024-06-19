import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PracticeTestGridData {
  final String title;
  final int answeredQuestions;
  final int totalQuestions;
  final double progress;
  final String background;

  PracticeTestGridData(
    this.title,
    this.answeredQuestions,
    this.totalQuestions,
    this.progress,
    this.background,
  );
}

class PracticeTestGrid extends StatelessWidget {
  final List<PracticeTestGridData> practiceTests;
  final Color mainColor;
  final Color backgroundColor;
  final Color textColor;

  final String title;

  final void Function(int index) onSelected;

  const PracticeTestGrid({
    super.key,
    required this.title,
    required this.practiceTests,
    this.mainColor = const Color(0xFFF6AF4D),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.textColor = Colors.white,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      ),
      body: SafeArea(
        child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
            ),
            itemCount: practiceTests.length,
            itemBuilder: (_, index) => _buildItem(practiceTests[index], index)),
      ),
    );
  }

  Widget _buildItem(PracticeTestGridData data, int index) => GestureDetector(
        onTap: () => onSelected(index),
        child: Container(
          margin: const EdgeInsets.all(5),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(data.background),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 1,
                  spreadRadius: 1,
                  offset: const Offset(0, 1))
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),

              // Questions
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: RichText(
                    text: TextSpan(children: [
                      const TextSpan(
                        text: '• ',
                      ),
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
                            TextSpan(text: data.progress.toInt().toString()),
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
      );
}
