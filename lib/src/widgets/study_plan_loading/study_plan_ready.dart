import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StudyPlanReadyScreen extends StatelessWidget {
  final Color backgroundColor;
  final Color mainColor;
  final String? image;
  final void Function() onStartLearning;

  const StudyPlanReadyScreen(
      {super.key,
      this.backgroundColor = const Color(0xFFEEFFFA),
      this.mainColor = const Color(0xFF579E89),
      this.image,
      required this.onStartLearning});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Your Personal Plan Is Ready!',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20),
                    height: 250,
                    width: double.infinity,
                    color: Colors.red,
                    child: const Center(
                      child: Text('GRAPH'),
                    ),
                  ),
                  Text(
                    _getDisplayDate(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInformationTile(
                                'assets/images/ready_reminder.svg',
                                'Reminder',
                                '10:00 am'),
                            _buildInformationTile(
                                'assets/images/ready_calendar.svg',
                                'Exam date',
                                _getDisplayDate(
                                    time: DateTime.now()
                                        .add(const Duration(days: 10)))),
                            _buildInformationTile(
                                'assets/images/ready_questions.svg',
                                'Reminder',
                                '56/day'),
                            _buildInformationTile('assets/images/ready_cup.svg',
                                'Reminder', '98%'),
                          ],
                        )),
                        if (image != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Image.asset(image!, height: 250),
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

  Widget _buildInformationTile(String icon, String title, String content) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(icon, color: mainColor, height: 40),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                Text(
                  content,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            )
          ],
        ),
      );

  _getDisplayDate({DateTime? time}) {
    final currentTime = time ?? DateTime.now();
    const List<String> monthNames = [
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

    // Ensure the month value is between 1 and 12
    if (currentTime.month < 1 || currentTime.month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return 'Today - ${monthNames[currentTime.month]} ${currentTime.day}, ${currentTime.year}';
  }
}
