import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CustomTestData {
  final String title;
  final int totalQuestions;
  final int doneQuestions;
  final int time;
  final double minPassValue;
  final bool isFinished;

  CustomTestData({
    required this.title,
    required this.totalQuestions,
    required this.time,
    required this.minPassValue,
    required this.doneQuestions,
    required this.isFinished,
  });
}

class CustomTestBox extends StatelessWidget {
  final Color passColor;
  final Color failColor;
  final Color mainColor;
  final Color secondaryColor;

  final bool isDarkMode;
  final bool isFinished;

  final String title;
  final int totalQuestions;
  final int doneQuestions;
  final int time;

  final double minPassValue;

  final bool isSelected;

  const CustomTestBox({
    super.key,
    required this.passColor,
    required this.failColor,
    required this.mainColor,
    required this.isDarkMode,
    required this.minPassValue,
    required this.isFinished,
    required this.title,
    required this.totalQuestions,
    required this.doneQuestions,
    required this.time,
    required this.secondaryColor,
    required this.isSelected,
  });

  TextStyle get infoTextStyle => const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(title),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.centerLeft,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.edit),
            SizedBox(width: 10),
            Text('Edit', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: (isFinished ? _getMainColor() : secondaryColor).withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 24,
              lineWidth: 5,
              percent: doneQuestions / totalQuestions,
              animation: true,
              progressColor: _getMainColor(),
              backgroundColor: Colors.grey.withOpacity(0.3),
              circularStrokeCap: CircularStrokeCap.round,
              center: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(((doneQuestions / totalQuestions) * 100).toStringAsFixed(0), style: const TextStyle(fontSize: 12)),
                  const Text('%', style: TextStyle(fontSize: 8)),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
              children: [
                Row(
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    if (isFinished)
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: _getMainColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Center(
                          child: Text(
                            (doneQuestions / totalQuestions) >= minPassValue ? 'PASSED' : 'FAILED',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: _getMainColor()),
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text('$doneQuestions/$totalQuestions', style: infoTextStyle),
                    Text(' Questions  ', style: infoTextStyle.copyWith(color: Colors.grey.shade600)),
                    Text('$time', style: infoTextStyle),
                    Text(' Minutes', style: infoTextStyle.copyWith(color: Colors.grey.shade600)),
                  ],
                )
              ],
            )),
            isSelected
                ? Checkbox(value: true, onChanged: (_) {})
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.more_horiz, color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }

  Color _getMainColor() => isFinished
      ? (doneQuestions / totalQuestions) * 100 >= minPassValue
          ? passColor
          : failColor
      : mainColor;
}
