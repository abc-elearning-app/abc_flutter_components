import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class InformationData {
  final Widget icon;
  final String title;
  final String content;

  InformationData({
    required this.icon,
    required this.title,
    required this.content,
  });
}

class PersonalPlanReadyScreen extends StatelessWidget {
  final Color backgroundColor;
  final Color mainColor;

  // Image
  final String sideImage;
  final Widget reminderIcon;
  final Widget examDateIcon;
  final Widget questionsIcon;
  final Widget passingScoreIcon;

  // Data
  final TimeOfDay? reminderTime;
  final int expectedQuestions;
  final double passingScore;
  final DateTime startDate;
  final DateTime examDate;
  final List<int> chartValueList;
  final bool isDarkMode;

  final void Function() onStartLearning;

  const PersonalPlanReadyScreen({
    super.key,
    this.reminderTime,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.mainColor = const Color(0xFFE3A651),
    required this.reminderIcon,
    required this.examDateIcon,
    required this.questionsIcon,
    required this.passingScoreIcon,
    required this.sideImage,
    required this.expectedQuestions,
    required this.passingScore,
    required this.onStartLearning,
    required this.isDarkMode,
    required this.startDate,
    required this.examDate,
    required this.chartValueList,
  });

  @override
  Widget build(BuildContext context) {
    final informationDataList = <InformationData>[
      InformationData(
          icon: reminderIcon,
          title: 'Reminder',
          content: _getDisplayReminderTime(reminderTime ?? TimeOfDay.now())),
      InformationData(
          icon: examDateIcon,
          title: 'Exam date',
          content: _getDisplayDate(time: examDate, displayFull: true)),
      InformationData(
          icon: questionsIcon,
          title: 'Questions',
          content: '$expectedQuestions/day'),
      InformationData(
          icon: passingScoreIcon,
          title: 'Passing Score',
          content: '${passingScore.toInt()}%')
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Title
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 40,
                        right: 40,
                        top: 20,
                      ),
                      child: Text(
                        'Your Personal Plan Is Ready!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: isDarkMode ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Chart
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 20,
                      ),
                      child: PersonalPlanChart(
                        key: GlobalKey(),
                        isDarkMode: isDarkMode,
                        lineSectionHeight: 120,
                        barSectionHeight: 150,
                        startDate: startDate,
                        examDate: examDate,
                        valueList: chartValueList,
                        expectedBarValue: expectedQuestions,
                      ),
                    ),

                    // Current date
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Today - ${_getDisplayDate(time: DateTime.now())}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),

                    // Detail information
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Information
                          Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: informationDataList.length,
                                  itemBuilder: (_, index) =>
                                      _buildInformationTile(
                                        informationDataList[index],
                                      ))),

                          // Image
                          Image.asset(sideImage, height: 180),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            _buildButton()
          ],
        ),
      ),
    );
  }

  Widget _buildInformationTile(InformationData data) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            data.icon,
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                      fontSize: 12,
                      color: (isDarkMode ? Colors.white : Colors.black)
                          .withOpacity(0.5)),
                ),
                Text(
                  data.content,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      color: isDarkMode ? Colors.white : Colors.black),
                )
              ],
            )
          ],
        ),
      );

  Widget _buildButton() => Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        width: double.infinity,
        child: MainButton(
          title: 'Start Learning',
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: mainColor,
          borderRadius: 16,
          textStyle: const TextStyle(fontSize: 18),
          onPressed: () => onStartLearning(),
        ),
      );

  _getDisplayReminderTime(TimeOfDay time) {
    final hour = time.hour <= 12 ? time.hour : time.hour - 12;
    final displayHour = hour < 10 ? '0$hour' : hour.toString();
    final displayMinute =
        time.minute < 10 ? '0${time.minute}' : time.minute.toString();
    return '$displayHour:$displayMinute ${time.hour <= 12 ? 'am' : 'pm'}';
  }

  _getDisplayDate({required DateTime time, bool displayFull = false}) {
    const List<String> abrMonthNames = [
      '', // Placeholder for 1-based indexing
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    const List<String> fullMonthNames = [
      '', // Placeholder for 1-based indexing
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${displayFull ? fullMonthNames[time.month] : abrMonthNames[time.month]} ${time.day}, ${time.year}';
  }
}
