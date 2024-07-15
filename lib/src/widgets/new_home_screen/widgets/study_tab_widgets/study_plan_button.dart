import 'package:flutter/material.dart';

class StudyPlanButton extends StatelessWidget {
  final String buttonBackground;
  final Color mainColor;
  final String title;
  final void Function() onClickStudyPlan;

  const StudyPlanButton({
    super.key,
    required this.buttonBackground,
    required this.onClickStudyPlan,
    required this.mainColor,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          onPressed: onClickStudyPlan,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white),
            ),
          )),
    );
  }
}
