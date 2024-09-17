import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/progress/custom_linear_progress.dart';

class PassingProbabilityComponent extends StatelessWidget {
  final double passingProbability;
  final Color mainColor;
  final bool isDarkMode;

  const PassingProbabilityComponent({
    super.key,
    required this.passingProbability,
    required this.mainColor,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isDarkMode
            ? Colors.white.withOpacity(0.16)
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
                '${(passingProbability * 100).ceil()}%',
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
              percent: passingProbability * 100,
              indicatorColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
