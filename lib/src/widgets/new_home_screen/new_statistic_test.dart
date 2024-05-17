import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/common/passing_probability_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/new_home_screen/widgets/statistic_tab_widgets/overview_box.dart';

class NewStatisticTab extends StatelessWidget {
  final int dayStreak;
  final double passingProbability;
  final Color mainColor;

  const NewStatisticTab(
      {super.key,
      this.mainColor = const Color(0xFFE3A651),
      required this.dayStreak,
      required this.passingProbability});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          PassingProbabilityBox(
            passingProbability: passingProbability,
            mainColor: mainColor,
            dayStreak: dayStreak,
          ),

          OverviewBox()
        ],
      ),
    );
  }
}
