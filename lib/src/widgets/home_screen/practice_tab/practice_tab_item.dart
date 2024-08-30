import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/percent_indicator.dart';

class QuestionGroupData {
  final int id;
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
  final bool proVersion;
  final double? progress;
  final int? passPercent;
  final bool? finished;
  final String proIcon;
  final void Function(int id) onSelect;

  const PracticeTabItemComponent({
    super.key,
    required this.questionGroupData,
    required this.isDarkMode,
    required this.onSelect,
    required this.proVersion,
    required this.proIcon,
    this.passPercent,
    this.progress,
    this.finished
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
            ),
            _makeProgress()
          ],
        ),
      ),
    );
  }

  Widget _makeProgress() {
    Widget? widget;
    if(finished == true && progress != null && passPercent != null && progress! >= passPercent!) {
      widget = const Icon(Icons.done_rounded, color: Colors.green, size: 40);
    } else if(finished == true && progress != null && passPercent != null && progress! < passPercent!) {
      widget = const Icon(Icons.close_rounded, color: Colors.red, size: 40);
    } else if(progress != null && progress! > -1) {
      widget = Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: 24,
            percent: progress!,
            lineWidth: 4,
            progressColor: Colors.green,
            backgroundColor: Colors.green.shade100,
          ),
          Text('${(progress! * 100).round().toString()}%', style: const TextStyle(fontSize: 12))
        ],
      );
    } else if(!proVersion) {
      widget = Image.asset(proIcon, width: 30);
    }
    if(widget != null) {
      return Padding(
        padding: const EdgeInsets.only(left: 12),
        child: widget,
      );
    }
    return const SizedBox();
  }
}
