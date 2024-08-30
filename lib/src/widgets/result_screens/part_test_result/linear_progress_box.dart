import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class LinearProgressBox extends StatelessWidget {
  final double passingProbability;
  final double improvedPercent;

  final Color backgroundColor;
  final Color progressColor;
  final Color improveColor;

  const LinearProgressBox({
    super.key,
    required this.passingProbability,
    required this.improvedPercent,
    required this.backgroundColor,
    required this.progressColor,
    required this.improveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Passing probability
          Column(
            children: [
              const Text('Passing Probability', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400)),
              Text('${(passingProbability * 100).ceil()}%', style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600))
            ],
          ),

          // Linear progress
          Expanded(
              child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Stack(children: [
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 30,
                      backgroundColor: Colors.transparent,
                      progressColor: improveColor,
                      percent: passingProbability.clamp(0, 1),
                    ),
                    LinearPercentIndicator(
                      padding: EdgeInsets.zero,
                      animation: true,
                      lineHeight: 30,
                      backgroundColor: Colors.transparent,
                      progressColor: progressColor,
                      percent: (passingProbability - improvedPercent).clamp(0, 1),
                    ),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RichText(
                    text: TextSpan(style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500), children: [
                  TextSpan(text: '+${(improvedPercent * 100).toInt()}'),
                  const TextSpan(text: '%', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700))
                ])),
              )
            ],
          ))
        ],
      ),
    );
  }
}
