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
  final String title;
  final bool isDarkMode;

  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;

  final void Function(int index) onSelected;

  const PracticeTestGrid({
    super.key,
    required this.title,
    required this.practiceTests,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.backgroundColor = const Color(0xFFF5F4EE),
    required this.onSelected,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
            itemBuilder: (_, index) => _buildItem(practiceTests[index], index)),
      ),
    );
  }

  Widget _buildItem(PracticeTestGridData data, int index) => GestureDetector(
        onTap: () => onSelected(index),
        child: Container(
          margin: const EdgeInsets.all(8),
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
                    data.title,
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
