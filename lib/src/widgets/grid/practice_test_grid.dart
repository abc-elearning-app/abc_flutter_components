import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

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
  });
}

class TestGrid extends StatelessWidget {
  final List<TestData> practiceTests;
  final String title;
  final bool isDarkMode;

  final Color mainColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(int index) onSelected;

  const TestGrid({
    super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.correctColor = const Color(0xFF15CB9F),
    this.incorrectColor = const Color(0xFFFC5656),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.title,
    required this.practiceTests,
    required this.onSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : backgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            )),
      ),
      body: SafeArea(
        child: GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
            ),
            itemCount: practiceTests.length,
            itemBuilder: (_, index) => _testBox(practiceTests[index], index)),
      ),
    );
  }

  Widget _testBox(TestData data, int index) => GestureDetector(
        onTap: () => onSelected(data.id),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(data.background),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 1, spreadRadius: 1, offset: const Offset(0, 1))] : null,
          ),
          child: Stack(children: [
            Positioned.fill(
                child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: (isDarkMode ? const Color(0xFF292929) : secondaryColor).withOpacity(0.92),
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
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),

                  // Questions
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          data.isDone
                              ? '• ${data.correctQuestions}/${data.totalQuestions} Correct'
                              : '• ${data.answeredQuestions}/${data.totalQuestions} Answered',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                  ),

                  // Progress
                  Stack(alignment: Alignment.centerRight, children: [
                    LinearPercentIndicator(
                      barRadius: const Radius.circular(15),
                      padding: EdgeInsets.zero,
                      percent: (data.isDone ? data.correct : data.progress) / 100,
                      progressColor: data.isDone ? correctColor : mainColor,
                      lineHeight: 25,
                      backgroundColor: data.isDone ? incorrectColor : Colors.white.withOpacity(0.5),
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
          ]),
        ),
      );
}
