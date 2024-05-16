import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../flutter_abc_jsc_components.dart';

class DiagnosticTestBox extends StatelessWidget {
  final String icon;
  final String background;

  final Color textColor;
  final Color progressColor;

  const DiagnosticTestBox(
      {super.key,
      required this.icon,
      required this.background,
      required this.textColor,
      required this.progressColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
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
                    Text('Diagnostic Test',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: textColor)),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'Poppins'),
                            children: const [
                          TextSpan(
                            text:
                                'Take our diagnostic test to assess your current level and get a ',
                          ),
                          TextSpan(
                              text: 'personalized study plan.',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ]))
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: LinearPercentIndicator(
              percent: 0.2,
              animation: true,
              barRadius: const Radius.circular(20),
              lineHeight: 8,
              progressColor: progressColor,
              backgroundColor: Colors.grey.shade200.withOpacity(0.3),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MainButton(
                title: 'Try Again',
                onPressed: () {},
                backgroundColor: Colors.transparent,
                textStyle: const TextStyle(fontSize: 16),
                textColor: textColor,
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.arrow_forward,
                    color: textColor,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
