import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class InformationData {
  final String icon;
  final String title;
  final String content;

  InformationData(this.icon, this.title, this.content);
}

class StudyPlanReadyScreen extends StatelessWidget {
  final Color backgroundColor;
  final Color mainColor;
  final String? image;

  // Image
  final String? chartImage;
  final String? reminderImage;
  final String? examDateImage;
  final String? questionsImage;
  final String? passingScoreImage;

  // Data
  final TimeOfDay? reminderTime;
  final DateTime? examDate;
  final int questions;
  final double passingScore;

  final void Function() onStartLearning;

  const StudyPlanReadyScreen({
    super.key,
    this.backgroundColor = const Color(0xFFEEFFFA),
    this.mainColor = const Color(0xFF579E89),
    this.image,
    this.chartImage,
    this.reminderImage,
    this.examDateImage,
    this.questionsImage,
    this.passingScoreImage,
    this.reminderTime,
    this.examDate,
    required this.questions,
    required this.passingScore,
    required this.onStartLearning,
  });

  @override
  Widget build(BuildContext context) {
    final informationDataList = <InformationData>[
      InformationData(reminderImage ?? 'assets/images/ready_reminder.svg',
          'Reminder', _getReminderTime(reminderTime ?? TimeOfDay.now())),
      InformationData(
          examDateImage ?? 'assets/images/ready_calendar.svg',
          'Exam date',
          _getDisplayDate(
              time: examDate ?? DateTime.now(), isFullDisplay: true)),
      InformationData(questionsImage ?? 'assets/images/ready_questions.svg',
          'Questions', '$questions/day'),
      InformationData(
          passingScoreImage ?? 'assets/images/ready_passing_score.svg',
          'Passing Score',
          '${passingScore.toInt()}%')
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Title
                  const Text(
                    'Your Personal Plan Is Ready!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),

                  // Chart image
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                        chartImage ?? 'assets/images/personal_plan_chart.png'),
                  ),

                  // Current date
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      'Today - ${_getDisplayDate(time: DateTime.now())}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                  ),

                  // Detail information
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: informationDataList.length,
                                itemBuilder: (_, index) =>
                                    _buildInformationTile(
                                        informationDataList[index]))),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Image.asset(
                              image ?? 'assets/images/ready_plan.png',
                              height: 250),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: MainButton(
                title: 'Start Learning',
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: mainColor,
                borderRadius: 16,
                textStyle: const TextStyle(fontSize: 18),
                onPressed: () => onStartLearning(),
              ),
            )
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
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  data.content,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                )
              ],
            )
          ],
        ),
      );

  _getReminderTime(TimeOfDay time) {
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
