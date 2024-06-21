import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';
import 'package:flutter_svg/svg.dart';

class PassingProbabilitySection extends StatelessWidget {
  final int dayStreak;
  final double passingProbability;

  final String streakIcon;
  final Color mainColor;
  final Color darkModeMainColor;

  final bool isDarkMode;

  const PassingProbabilitySection({
    super.key,
    required this.passingProbability,
    required this.mainColor,
    required this.darkModeMainColor,
    required this.dayStreak,
    required this.isDarkMode,
    this.streakIcon = 'assets/images/fire.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _streakCircle(),
        Expanded(child: _passingProbabilityBox()),
      ],
    );
  }

  Widget _streakCircle() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                      width: 4,
                      color: isDarkMode ? darkModeMainColor : mainColor)),
              child: SvgPicture.asset(streakIcon)),
          Transform.translate(
            offset: const Offset(0, 10),
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
                style: const TextStyle(color: Colors.white),
              )),
            ),
          )
        ],
      );

  Widget _passingProbabilityBox() => Container(
        margin: const EdgeInsets.only(left: 20),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
                Text(
                  '${passingProbability.toInt()}%',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.white : Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: CustomLinearProgress(
                mainColor: mainColor,
                backgroundColor: Colors.white.withOpacity(isDarkMode ? 0.3 : 1),
                percent: passingProbability,
                indicatorColor: Colors.white,
              ),
            )
          ],
        ),
      );
}
