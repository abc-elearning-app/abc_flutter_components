import 'package:flutter/material.dart';

class TodayQuestionButton extends StatelessWidget {
  final String title;
  final String? buttonBackground;

  const TodayQuestionButton(
      {super.key, this.buttonBackground, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30, bottom: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          // color: Colors.green,
          image: DecorationImage(
              image: AssetImage(
                  buttonBackground ?? 'assets/images/button_background.png'),
              fit: BoxFit.cover)),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12))),
          onPressed: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          )),
    );
  }
}
