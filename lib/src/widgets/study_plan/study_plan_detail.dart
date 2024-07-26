import 'package:flutter/material.dart';

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

class StudyPlanDetailComponent extends StatelessWidget {
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
  final DateTime examDate;
  final bool isDarkMode;
  final bool isNotificationEnabled;

  const StudyPlanDetailComponent({
    super.key,
    this.reminderTime,
    required this.reminderIcon,
    required this.examDateIcon,
    required this.questionsIcon,
    required this.passingScoreIcon,
    required this.sideImage,
    required this.expectedQuestions,
    required this.passingScore,
    required this.isDarkMode,
    required this.examDate,
    required this.isNotificationEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final informationDataList = <InformationData>[
      if (isNotificationEnabled && reminderTime != null)
        InformationData(icon: reminderIcon, title: 'Reminder', content: _getDisplayReminderTime(reminderTime!)),
      InformationData(icon: examDateIcon, title: 'Exam date', content: _getDisplayDate(time: examDate, displayFull: true)),
      InformationData(icon: questionsIcon, title: 'Questions', content: '$expectedQuestions/day'),
      InformationData(icon: passingScoreIcon, title: 'Passing Score', content: '${passingScore.toInt()}%')
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Information
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: informationDataList.length,
                itemBuilder: (_, index) => _buildInformationTile(
                      informationDataList[index],
                    ))),

        // Image
        Image.asset(sideImage, height: 180),
      ],
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
                  style: TextStyle(fontSize: 12, color: (isDarkMode ? Colors.white : Colors.black).withOpacity(0.5)),
                ),
                Text(
                  data.content,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: isDarkMode ? Colors.white : Colors.black),
                )
              ],
            )
          ],
        ),
      );

  _getDisplayReminderTime(TimeOfDay time) {
    final hour = time.hour <= 12 ? time.hour : time.hour - 12;
    final displayHour = hour < 10 ? '0$hour' : hour.toString();
    final displayMinute = time.minute < 10 ? '0${time.minute}' : time.minute.toString();
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
