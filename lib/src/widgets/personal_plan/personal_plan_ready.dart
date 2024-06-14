import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../flutter_abc_jsc_components.dart';

class InformationData {
  final String icon;
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
  final String chartImage;
  final String reminderIcon;
  final String examDateIcon;
  final String questionsIcon;
  final String passingScoreIcon;

  // Data
  final TimeOfDay? reminderTime;
  final DateTime? examDate;
  final int questions;
  final double passingScore;
  final bool isDarkMode;

  final void Function() onStartLearning;

  const PersonalPlanReadyScreen({
    super.key,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.mainColor = const Color(0xFFE3A651),
    this.sideImage = 'assets/images/ready_soldier.png',
    this.chartImage = 'assets/images/personal_plan_chart.png',
    this.reminderIcon = 'assets/images/ready_reminder.svg',
    this.examDateIcon = 'assets/images/ready_calendar.svg',
    this.questionsIcon = 'assets/images/ready_questions.svg',
    this.passingScoreIcon = 'assets/images/ready_passing_score.svg',
    this.reminderTime,
    this.examDate,
    required this.questions,
    required this.passingScore,
    required this.onStartLearning,
    required this.isDarkMode,
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
          content: _getDisplayDate(
              time: examDate ?? DateTime.now(), isFullDisplay: true)),
      InformationData(
          icon: questionsIcon, title: 'Questions', content: '$questions/day'),
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
                    const SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        'Your Personal Plan Is Ready!',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 26,
                            color: isDarkMode ? Colors.white : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    // Chart image
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Image.asset(chartImage),
                    ),

                    // Current date
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        'Today - ${_getDisplayDate(time: DateTime.now())}',
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: isDarkMode ? Colors.white : Colors.black),
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
                                          informationDataList[index]))),

                          // Image
                          Transform.translate(
                              offset: const Offset(0, 50),
                              child: Image.asset(sideImage, height: 250))
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
            SvgPicture.asset(data.icon, height: 40),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.5)),
                ),
                Text(
                  data.content,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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

  _getDisplayDate({required DateTime time, bool isFullDisplay = false}) {
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
    // Ensure the month value is between 1 and 12
    if (time.month < 1 || time.month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return '${isFullDisplay ? fullMonthNames[time.month] : abrMonthNames[time.month]} ${time.day}, ${time.year}';
  }
}
