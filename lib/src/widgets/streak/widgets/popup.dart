import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StreakPopup extends StatelessWidget {
  final Color mainColor;
  final Color shieldColor;

  final bool isShield;

  final void Function() onClick;

  const StreakPopup({
    super.key,
    required this.mainColor,
    required this.shieldColor,
    required this.isShield,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset('assets/images/streak_drop_down.svg'),
        Container(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 50),
          width: double.infinity,
          margin: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
              color: Color(0xFFF5F4EE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              )),
          child: Column(
            children: [
              Image.asset('assets/images/popup_streak_challenge.png'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Streak Challenge',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black.withOpacity(0.6)),
                      children: const [
                    TextSpan(text: 'Keep your achievements in '),
                    TextSpan(
                        text: '30 days!',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ])),
              Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: MainButton(
                    title: 'Join Challenge',
                    backgroundColor: mainColor,
                    borderRadius: 15,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                    onPressed: onClick),
              )
            ],
          ),
        )
      ],
    );
  }
}
