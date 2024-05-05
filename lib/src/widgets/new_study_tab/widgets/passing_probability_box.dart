import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PassingProbabilityBox extends StatelessWidget {
  final Color mainColor;
  final double passingProbability;

  const PassingProbabilityBox({
    super.key,
    required this.passingProbability,
    required this.mainColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: mainColor.withOpacity(0.16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Passing Probability',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
              Text(
                '${passingProbability.toInt()}%',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: LinearPercentIndicator(
              padding: EdgeInsets.zero,
              lineHeight: 10,
              animation: true,
              barRadius: const Radius.circular(15),
              backgroundColor: Colors.white,
              progressColor: mainColor,
              percent: passingProbability / 100,
              widgetIndicator: Transform.translate(
                  offset: const Offset(-15, 0),
                  child: Transform.scale(
                      scale: 0.6,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: mainColor,
                        child: const CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.white,
                        ),
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
