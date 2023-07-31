import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PartProgressIndicator extends StatelessWidget {
  final String name;
  final int correct;
  final int total;
  final Color passedColor;
  final Color failedColor;
  final int requiredPass; // bỏ
  const PartProgressIndicator({
    super.key,
    this.correct = 0,
    this.name = "",
    this.total = 1,
    this.passedColor = Colors.green,
    this.failedColor = Colors.red,
    this.requiredPass = 0,
  });

  @override
  Widget build(BuildContext context) {
    int percentComplete = ((correct / total) * 100).toInt();
    Color percentColor = passedColor;
    if (requiredPass > 0 && percentComplete < requiredPass) {
      percentColor = failedColor;
    }
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                  child: Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              )),
              const SizedBox(width: 10),
              Text('($correct / $total)'),
              const SizedBox(width: 10),
              Text('$percentComplete %',
                  style: const TextStyle(fontWeight: FontWeight.bold))
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: LinearPercentIndicator(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              lineHeight: 8,
              animation: true,
              percent: correct / total,
              progressColor: percentColor,
              backgroundColor: Colors.grey[300],
            ),
          )
        ],
      ),
    );
  }
}
