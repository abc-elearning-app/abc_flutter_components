import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionGroupData {
  final String title;
  final String subtitle;
  final String icon;
  final Color iconBackgroundColor;
  final void Function() onClick;

  QuestionGroupData(
    this.title,
    this.subtitle,
    this.icon,
    this.iconBackgroundColor,
    this.onClick,
  );
}

class NewPracticeTab extends StatelessWidget {
  final List<QuestionGroupData> groupList;

  const NewPracticeTab({super.key, required this.groupList});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: List.generate(
            groupList.length, (index) => _buildQuestionGroup(groupList[index])),
      ),
    );
  }

  Widget _buildQuestionGroup(QuestionGroupData questionGroupData) => GestureDetector(
    onTap: questionGroupData.onClick,
    child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade300, spreadRadius: 1, blurRadius: 1)
              ]),
          child: Row(
            children: [
              Container(
                  height: 60,
                  width: 60,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: questionGroupData.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(15)),
                  child: SvgPicture.asset(
                      'assets/images/${questionGroupData.icon}.svg')),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      questionGroupData.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 18),
                    ),
                    Text(
                      questionGroupData.subtitle,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
  );
}
