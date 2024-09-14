import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:text_scroll/text_scroll.dart';

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

  final double? progress;
  final int? passPercent;
  final bool? finished;

  final bool isDarkMode;
  final bool? proVersion;

  final String? proIcon;
  final String? correctIcon;
  final String? incorrectIcon;

  final Color? mainColor;

  final void Function(int id) onSelect;

  const PracticeTabItemComponent({
    super.key,
    required this.questionGroupData,
    required this.isDarkMode,
    required this.onSelect,
    this.proIcon,
    this.proVersion,
    this.passPercent,
    this.progress,
    this.finished,
    this.correctIcon,
    this.incorrectIcon,
    this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    double iconSize = screenHeight < 900 ? 60 : 70;
    return GestureDetector(
      onTap: () => onSelect(questionGroupData.id),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: screenHeight < 700 ? 8 : 10),
        padding: EdgeInsets.all(screenHeight < 700 ? 12 : 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isDarkMode ? Colors.grey.shade900 : Colors.white,
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade200, blurRadius: 5, spreadRadius: 2)] : null),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                  height: iconSize,
                  width: iconSize,
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.only(
                    left: screenWidth / 90,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    color: questionGroupData.iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconWidget(icon: questionGroupData.icon)),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        questionGroupData.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(width: 10),
                      if (proVersion == false) GetProIcon(darkMode: isDarkMode, proIcon: proIcon ?? '', height: 25, width: 70)
                    ],
                  ),
                  screenHeight < 700
                      ? TextScroll(
                          key: GlobalKey(),
                          questionGroupData.subtitle,
                          style: const TextStyle(fontSize: 12),
                          velocity: const Velocity(pixelsPerSecond: Offset(10, 0)),
                          numberOfReps: 3,
                          pauseBetween: const Duration(seconds: 3),
                          pauseOnBounce: const Duration(seconds: 3),
                          delayBefore: const Duration(seconds: 3),
                          mode: TextScrollMode.bouncing,
                        )
                      : Text(
                          questionGroupData.subtitle,
                          style: const TextStyle(fontSize: 12),
                          maxLines: screenHeight < 700 ? 1 : 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ),
            if (proVersion == true) _progressIndicator()
          ],
        ),
      ),
    );
  }

  Widget _progressIndicator() {
    late Widget widget;
    if (finished == true && progress != null && passPercent != null && progress! >= passPercent!) {
      widget = IconWidget(icon: correctIcon ?? '');
    } else if (finished == true && progress != null && passPercent != null && progress! < passPercent!) {
      widget = IconWidget(icon: incorrectIcon ?? '');
    } else if (progress != null && progress! > -1) {
      widget = Stack(
        alignment: Alignment.center,
        children: [
          CircularPercentIndicator(
            radius: 20,
            percent: progress!,
            lineWidth: 5,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: mainColor,
            backgroundColor: mainColor?.withOpacity(0.3) ?? Colors.grey.shade100,
          ),
          Text('${(progress! * 100).round().toString()}%', style: TextStyle(fontSize: 10, color: isDarkMode ? Colors.white : Colors.black))
        ],
      );
    } else {
      widget = const SizedBox.shrink();
    }

    return Transform.translate(
      offset: progress != null && progress! > -1 ? const Offset(0, 0) : const Offset(8, -25),
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: widget,
      ),
    );
  }
}
