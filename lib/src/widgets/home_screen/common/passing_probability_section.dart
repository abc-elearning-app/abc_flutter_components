import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';

class PassingProbabilityComponent extends StatelessWidget {
  final int dayStreak;
  final double passingProbability;

  final String streakIcon;
  final Color mainColor;
  final Color darkModeMainColor;

  final bool isDarkMode;

  const PassingProbabilityComponent({
    super.key,
    required this.passingProbability,
    required this.mainColor,
    required this.darkModeMainColor,
    required this.dayStreak,
    required this.isDarkMode,
    required this.streakIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // _streakCircle(),
        Expanded(child: _passingProbabilityBox()),
      ],
    );
  }

  Widget _streakCircle() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    width: 4,
                    color: isDarkMode ? darkModeMainColor : mainColor,
                  )),
              child: IconWidget(icon: streakIcon)),
          Transform.translate(
            offset: const Offset(0, 5),
            child: Container(
              width: 45,
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                color: isDarkMode ? darkModeMainColor : mainColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                  child: Text(
                dayStreak.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              )),
            ),
          )
        ],
      );

  Widget _passingProbabilityBox() => Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isDarkMode
              ? darkModeMainColor.withOpacity(0.3)
              : mainColor.withOpacity(0.16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Passing Probability',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                Text(
                  '${passingProbability.toInt()}%',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: CustomLinearProgress(
                mainColor: mainColor,
                backgroundColor: Colors.white.withOpacity(isDarkMode ? 0.3 : 1),
                percent: passingProbability,
                indicatorColor: Colors.white,
              ),
            ),
          ],
        ),
      );
}
