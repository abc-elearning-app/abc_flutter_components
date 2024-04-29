import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

enum LevelType { beginner, intermediate, advanced }

class GeneralResultBox extends StatelessWidget {
  final Color boxColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color linearProgressColor;
  final String? beginnerImage;
  final String? intermediateImage;
  final String? advancedImage;
  final String? circleProgressImage;
  final double levelImageScale;
  final DateTime testDate;
  final double mainProgress;

  const GeneralResultBox({
    super.key,
    this.boxColor = Colors.white,
    required this.beginnerColor,
    required this.intermediateColor,
    required this.advancedColor,
    this.circleProgressImage,
    this.linearProgressColor = const Color(0xFF77C4FC),
    this.beginnerImage,
    this.intermediateImage,
    this.advancedImage,
    this.levelImageScale = 1.2,
    required this.testDate,
    required this.mainProgress,
  });

  @override
  Widget build(BuildContext context) {
    final levelType = _getLevel();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: boxColor,
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Date Of Test :',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  _getDisplayDate(testDate),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your Level :',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  _getLevelTitle(levelType),
                  style: TextStyle(
                      fontSize: 18,
                      color: _getLevelColor(levelType),
                      fontWeight: FontWeight.bold),
                ),
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
              progressColor: linearProgressColor,
              backgroundColor: Colors.grey.withOpacity(0.2),
            ),
            _buildLevelRow(levelType)
          ]),
        ],
      ),
    );
  }

  Widget _buildCircleProgress(LevelType levelType) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: CircleAvatar(
          radius: 130,
          backgroundColor: _getLevelColor(levelType).withOpacity(0.3),
          child: CircleAvatar(
            radius: 115,
            backgroundColor: _getLevelColor(levelType),
            child: Stack(alignment: Alignment.center, children: [
              const CircleAvatar(
                radius: 98,
                backgroundColor: Colors.white,
              ),
              CircleAvatar(
                radius: 98,
                backgroundColor: _getLevelColor(levelType).withOpacity(0.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (circleProgressImage != null)
                      SizedBox(
                          height: 80, child: Image.asset(circleProgressImage!)),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('Your result is',
                          style: TextStyle(
                              fontSize: 18, color: _getLevelColor(levelType))),
                    ),
                    Text('${mainProgress.toInt()}%',
                        style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: _getLevelColor(levelType)))
                  ],
                ),
              ),
            ]),
          ),
        ),
      );

  Widget _buildLevelRow(LevelType levelType) =>
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildLevel(LevelType.beginner, beginnerImage, true),
        _buildLevel(
            LevelType.intermediate, intermediateImage, mainProgress >= 20),
        _buildLevel(LevelType.advanced, advancedImage, mainProgress >= 80),
      ]);

  Widget _buildLevel(LevelType type, String? image, bool isUnlocked) {
    const lockOpacity = 0.5;
    const radius = 40.0;
    const backGroundOpacity = 0.7;
    return Stack(
      alignment: Alignment.center,
      children: [
        const CircleAvatar(
          radius: radius,
          backgroundColor: Colors.white,
        ),
        Opacity(
          opacity: isUnlocked ? 1 : lockOpacity,
          child: CircleAvatar(
            radius: radius,
            backgroundColor:
            _getLevelColor(type).withOpacity(backGroundOpacity),
            child: Transform.scale(
                scale: levelImageScale,
                child: image != null ? Image.asset(image) : const SizedBox()),
          ),
        ),
        Transform.translate(
            offset: const Offset(0, 50),
            child: Opacity(
              opacity: isUnlocked ? 1 : lockOpacity,
              child: Text(
                _getLevelTitle(type),
                style: TextStyle(
                    color: _getLevelColor(type),
                    fontSize: 15,
                    fontWeight: FontWeight.w500),
              ),
            ))
      ],
    );
  }

  _getLevel() {
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

  _getLevelColor(LevelType type) {
    switch (type) {
      case LevelType.beginner:
        return beginnerColor;
      case LevelType.intermediate:
        return intermediateColor;
      case LevelType.advanced:
        return advancedColor;
    }
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

    // Ensure the month value is between 1 and 12
    if (time.month < 1 || time.month > 12) {
      throw ArgumentError('Month must be between 1 and 12');
    }

    return '${monthNames[time.month]} ${time.day}, ${time.year}';
  }
}
