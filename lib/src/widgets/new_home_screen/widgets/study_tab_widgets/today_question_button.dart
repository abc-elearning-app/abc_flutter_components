import 'package:flutter/material.dart';

class TodayQuestionButton extends StatelessWidget {
  final String buttonBackground;
  final void Function() onClickDailyChallenge;

  const TodayQuestionButton({
    super.key,
    required this.buttonBackground,
    required this.onClickDailyChallenge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(
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
                  fontSize: 20,
                  color: Colors.white),
            ),
          )),
    );
  }
}
