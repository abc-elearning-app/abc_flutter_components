import 'package:flutter/material.dart';

class DailyChallengeButton extends StatelessWidget {
  final String buttonBackground;
  final Color mainColor;
  final void Function() onClickDailyChallenge;

  const DailyChallengeButton({
    super.key,
    required this.buttonBackground,
    required this.onClickDailyChallenge,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(
          color: mainColor,
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
              image: AssetImage(buttonBackground), fit: BoxFit.cover)),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16))),
          onPressed: onClickDailyChallenge,
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              "Daily Challenge",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          )),
    );
  }
}
