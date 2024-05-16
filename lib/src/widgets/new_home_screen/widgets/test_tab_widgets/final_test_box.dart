import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FinalTestBox extends StatelessWidget {
  final String icon;
  final String background;

  final Color textColor;
  final Color progressColor;

  final int answeredQuestions;
  final int totalQuestions;
  final double correctPercent;

  const FinalTestBox(
      {super.key,
      required this.icon,
      required this.background,
      required this.textColor,
      required this.progressColor,
      required this.answeredQuestions,
      required this.totalQuestions,
      required this.correctPercent});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(background), fit: BoxFit.cover),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 2,
                spreadRadius: 2,
                offset: const Offset(0, 1))
          ],
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Image.asset(icon),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Final Test',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor)),
                    Text(
                        'Our final test is the ultimate gauge that assesses your readiness for the actual exam.',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: textColor)),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearPercentIndicator(
              percent: 0.3,
              animation: true,
              barRadius: const Radius.circular(20),
              lineHeight: 10,
              progressColor: progressColor,
              backgroundColor: Colors.grey.shade200.withOpacity(0.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: textColor),
                      children: [
                    TextSpan(text: answeredQuestions.toString()),
                    TextSpan(
                        text: '/$totalQuestions Answered',
                        style: TextStyle(
                            fontSize: 14, color: textColor.withOpacity(0.5)))
                  ])),
              Text(
                '${correctPercent.toInt()}% Correct',
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: textColor),
              )
            ],
          )
        ],
      ),
    );
  }
}
