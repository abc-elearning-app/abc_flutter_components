import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stroke_text/stroke_text.dart';

class StreakGeneralSection extends StatelessWidget {
  final Color mainColor;
  final int dayStreak;

  const StreakGeneralSection({
    super.key,
    required this.mainColor,
    required this.dayStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/streak_background.png'),
                fit: BoxFit.cover)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StrokeText(
                      text: dayStreak.toString(),
                      textStyle: TextStyle(
                        fontSize: 10,
                        color: mainColor,
                      ),
                      strokeColor: Colors.white,
                      textScaler: const TextScaler.linear(6),
                      strokeWidth: 6),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: StrokeText(
                        text: 'Day Streak',
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: mainColor,
                        ),
                        strokeColor: Colors.white,
                        strokeWidth: 3),
                  ),
                ],
              ),
              SvgPicture.asset('assets/images/streak_fire.svg')
            ],
          ),
        ));
  }
}
