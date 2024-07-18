import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ResultSubjectTile extends StatelessWidget {
  final String title;
  final String icon;
  final double progress;
  final Color color;
  final Color iconBackgroundColor;
  final bool isDarkMode;

  final String beginnerIcon;
  final String intermediateIcon;
  final String advancedIcon;

  const ResultSubjectTile({
    super.key,
    required this.title,
    required this.icon,
    required this.progress,
    required this.color,
    required this.beginnerIcon,
    required this.intermediateIcon,
    required this.advancedIcon,
    required this.isDarkMode,
    required this.iconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
        boxShadow: !isDarkMode
            ? [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 1,
                    offset: const Offset(0, 1))
              ]
            : null,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color.lerp(iconBackgroundColor, Colors.white, 0.7),
                ),
                child: IconWidget(icon: icon, color: color, height: 25),
              ),

              // Title
              Expanded(
                  child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    overflow: TextOverflow.ellipsis),
              )),
              Text(
                '${progress.ceil()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              )
            ],
          ),

          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: List.generate(
                10,
                (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 10,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: index < progress / 10
                            ? color
                            : isDarkMode
                                ? Colors.white.withOpacity(0.12)
                                : Colors.black.withOpacity(0.08)),
                  ),
                ),
              ),
            ),
          ),

          // Level
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconWidget(
                icon: _getLevelIcon(),
                color: color,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              Text(
                _getLevelTitle(),
                style: TextStyle(
                    fontSize: 12,
                    color: (isDarkMode ? Colors.white : Colors.black)
                        .withOpacity(0.5)),
              ),
            ],
          )
        ],
      ),
    );
  }

  _getLevelIcon() {
    if (progress < 20) {
      return beginnerIcon;
    } else if (progress < 80) {
      return intermediateIcon;
    } else {
      return advancedIcon;
    }
  }

  _getLevelTitle() {
    if (progress < 20) {
      return 'Beginner';
    } else if (progress < 80) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }
}
