import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StreakCircle extends StatelessWidget {
  final Color mainColor;
  final String? streakIcon;
  final int dayStreak;

  const StreakCircle(
      {super.key,
      required this.mainColor,
      required this.dayStreak,
      this.streakIcon});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(width: 4, color: mainColor)),
            child: SvgPicture.asset(streakIcon ?? 'assets/images/fire.svg')),
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
              style: TextStyle(color: Colors.white),
            )),
          ),
        )
      ],
    );
  }
}
