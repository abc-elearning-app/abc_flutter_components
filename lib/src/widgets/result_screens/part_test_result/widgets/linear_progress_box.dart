import 'package:flutter/material.dart';

class LinearProgressBox extends StatelessWidget {
  final double passingProbability;
  final double improvedPercent;

  final Color backgroundColor;
  final Color progressColor;
  final Color improveColor;
  final Color textColor;

  const LinearProgressBox(
      {super.key,
      required this.passingProbability,
      required this.improvedPercent,
      this.backgroundColor = const Color(0xFF7C6F5B),
      this.progressColor = const Color(0xFFE3A651),
      this.improveColor = const Color(0xFF38EFAE),
      this.textColor = Colors.white});

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
              Text('Passing Probability',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
              Text('${passingProbability.toInt()}%',
                  style: TextStyle(
                      color: textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w600))
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
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: textColor),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                        color: progressColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)),
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 10,
                      decoration: BoxDecoration(
                        color: improveColor,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: RichText(
                    text: TextSpan(
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                        children: [
                      TextSpan(text: '+${improvedPercent.toInt()}'),
                      const TextSpan(
                          text: '%',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700))
                    ])),
              )
            ],
          ))
        ],
      ),
    );
  }
}
