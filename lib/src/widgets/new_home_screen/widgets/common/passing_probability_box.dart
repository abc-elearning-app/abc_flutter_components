import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PassingProbabilityBox extends StatelessWidget {
  final int dayStreak;
  final double passingProbability;

  final String streakIcon;
  final Color mainColor;

  const PassingProbabilityBox({
    super.key,
    required this.passingProbability,
    required this.mainColor,
    required this.dayStreak,
    this.streakIcon = 'assets/images/fire.svg',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStreakCircle(),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: mainColor.withOpacity(0.16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Passing Probability',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${passingProbability.toInt()}%',
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LinearPercentIndicator(
                    padding: EdgeInsets.zero,
                    lineHeight: 10,
                    animation: true,
                    barRadius: const Radius.circular(15),
                    backgroundColor: Colors.white,
                    progressColor: mainColor,
                    percent: passingProbability / 100,
                    widgetIndicator: Transform.translate(
                        offset: const Offset(-15, 0),
                        child: Transform.scale(
                            scale: 0.6,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: mainColor,
                              child: const CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.white,
                              ),
                            ))),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakCircle() => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 4, color: mainColor)),
              child: SvgPicture.asset(streakIcon)),
          Transform.translate(
            offset: const Offset(0, 10),
            child: Container(
              width: 45,
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                color: mainColor,
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
}