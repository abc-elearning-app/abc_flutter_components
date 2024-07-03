import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/percent_indicator.dart';

enum LevelType { beginner, intermediate, advanced }

class GeneralResultBox extends StatelessWidget {
  final DateTime testDate;
  final double mainProgress;
  final bool isDarkMode;

  // Colors
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color beginnerBackgroundColor;
  final Color intermediateBackgroundColor;
  final Color advancedBackgroundColor;

  // Images
  final String beginnerImage;
  final String intermediateImage;
  final String advancedImage;
  final String circleProgressImage;

  const GeneralResultBox({
    super.key,
    required this.beginnerColor,
    required this.intermediateColor,
    required this.advancedColor,
    required this.circleProgressImage,
    required this.beginnerImage,
    required this.intermediateImage,
    required this.advancedImage,
    required this.testDate,
    required this.mainProgress,
    required this.beginnerBackgroundColor,
    required this.intermediateBackgroundColor,
    required this.advancedBackgroundColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    final levelType = _getLevelType();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: !isDarkMode
            ? [
                BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 1,
                    offset: const Offset(0, 1))
              ]
            : null,
        color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date Of Test :',
                  style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                Text(
                  _getDisplayDate(testDate),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                const SizedBox(height: 10),
                Text('Your Level :',
                    style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black)),
                Text(_getLevelTitle(levelType),
                    style: TextStyle(
                        fontSize: 16,
                        color: _getLevelColor(levelType),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          // Circle progress section
          _buildCircleProgress(levelType),

          // Level progress
          Stack(alignment: Alignment.center, children: [
            LinearPercentIndicator(
              lineHeight: 8,
              animation: true,
              percent: _getLinearValue(levelType),
              progressColor: _getProgressLineColor(levelType),
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
            _buildLevelRow(levelType)
          ]),
        ],
      ),
    );
  }

  Widget _buildCircleProgress(LevelType levelType) {
    const double outerRadius = 120;
    const double lineWidth = 16;

    return Stack(alignment: Alignment.center, children: [
      const CircleAvatar(radius: outerRadius, backgroundColor: Colors.white),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CircularPercentIndicator(
          radius: outerRadius,
          lineWidth: lineWidth,
          backgroundColor: _getLevelColor(levelType).withOpacity(0.15),
          center: CircularPercentIndicator(
            radius: outerRadius - lineWidth,
            lineWidth: lineWidth,
            circularStrokeCap: CircularStrokeCap.round,
            percent: mainProgress / 100,
            animation: true,
            backgroundColor: _getLevelColor(levelType).withOpacity(0.5),
            progressColor: _getLevelColor(levelType),
            center: CircleAvatar(
              radius: outerRadius - 2 * lineWidth,
              backgroundColor: _getLevelColor(levelType).withOpacity(0.05),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconWidget(icon: circleProgressImage, height: 80),
                  Text(
                    'Your result is',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getLevelColor(levelType),
                    ),
                  ),
                  Text(
                    '${mainProgress.toInt()}%',
                    style: TextStyle(
                        color: _getLevelColor(levelType),
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  Widget _buildLevelRow(LevelType levelType) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildLevel(
          LevelType.beginner,
          beginnerImage,
          true,
        ),
        _buildLevel(
          LevelType.intermediate,
          intermediateImage,
          mainProgress >= 20,
        ),
        _buildLevel(
          LevelType.advanced,
          advancedImage,
          mainProgress >= 80,
        ),
      ]);

  Widget _buildLevel(LevelType type, String image, bool isUnlocked) => Stack(
        alignment: Alignment.center,
        children: [
          // Background to avoid see through
          CircleAvatar(
            radius: 35,
            backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.white,
          ),
          Opacity(
            opacity: isUnlocked ? 1 : 0.5,
            child: CircleAvatar(
                radius: 35,
                backgroundColor: _getLevelBackgroundColor(type),
                child: IconWidget(icon: image, height: 50)),
          ),
          Opacity(
            opacity: isUnlocked ? 1 : 0.8,
            child: Transform.translate(
                offset: const Offset(0, 50),
                child: Text(_getLevelTitle(type),
                    style: TextStyle(
                        color: _getLevelColor(type),
                        fontSize: 14,
                        fontWeight: FontWeight.w500))),
          )
        ],
      );

  _getLevelType() {
    if (mainProgress < 20) {
      return LevelType.beginner;
    } else if (mainProgress < 80) {
      return LevelType.intermediate;
    } else {
      return LevelType.advanced;
    }
  }

  _getLinearValue(LevelType levelType) {
    switch (levelType) {
      case LevelType.beginner:
        return 0.0;
      case LevelType.intermediate:
        return 0.5;
      case LevelType.advanced:
        return 1.0;
    }
  }

  _getLevelTitle(LevelType type) {
    switch (type) {
      case LevelType.beginner:
        return 'Beginner';
      case LevelType.intermediate:
        return 'Intermediate';
      case LevelType.advanced:
        return 'Advanced';
    }
  }

  Color _getLevelColor(LevelType type) {
    switch (type) {
      case LevelType.beginner:
        return beginnerColor;
      case LevelType.intermediate:
        return intermediateColor;
      case LevelType.advanced:
        return advancedColor;
    }
  }

  Color _getLevelBackgroundColor(LevelType type) {
    switch (type) {
      case LevelType.beginner:
        return beginnerBackgroundColor;
      case LevelType.intermediate:
        return intermediateBackgroundColor;
      case LevelType.advanced:
        return Color.lerp(
          advancedBackgroundColor,
          Colors.black,
          isDarkMode ? 0.3 : 0,
        )!;
    }
  }

  Color _getProgressLineColor(LevelType type) {
    if (type == LevelType.intermediate) return beginnerBackgroundColor;
    return advancedBackgroundColor;
  }

  _getDisplayDate(DateTime time) {
    const List<String> monthNames = [
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

    return '${monthNames[time.month]} ${time.day}, ${time.year}';
  }
}
