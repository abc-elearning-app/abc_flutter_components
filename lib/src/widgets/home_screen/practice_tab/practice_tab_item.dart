import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class QuestionGroupData {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final Color iconBackgroundColor;

  QuestionGroupData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.id,
    this.iconBackgroundColor = Colors.grey,
  });
}

class PracticeTabItemComponent extends StatelessWidget {
  final QuestionGroupData questionGroupData;
  final bool isDarkMode;
  final void Function(String id) onSelect;

  const PracticeTabItemComponent({
    super.key,
    required this.questionGroupData,
    required this.isDarkMode,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(questionGroupData.id),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isDarkMode ? Colors.grey.shade800 : Colors.white,
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 2)] : null),
        child: Row(
          children: [
            Container(
                height: 60,
                width: 60,
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  color: questionGroupData.iconBackgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconWidget(icon: questionGroupData.icon)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    questionGroupData.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(questionGroupData.subtitle, style: const TextStyle(fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
