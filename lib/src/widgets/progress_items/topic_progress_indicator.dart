import 'package:flutter/material.dart';

class TopicProgressIndicator extends StatelessWidget {
  final Color color;
  final double progress;
  final Widget? training;
  final Axis axis;

  final _height = 5.0;

  const TopicProgressIndicator(
      {super.key,
      required this.color,
      required this.progress,
      this.training,
      this.axis = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: axis,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(
                    height: _height,
                    color: color.withOpacity(0.1),
                  ),
                  AnimatedContainer(
                    height: _height,
                    width: (progress / 100) * constraints.maxWidth,
                    color: color,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
              );
            },
          ),
        ),
        training ??
            Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: Text(
                "$progress%",
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            )
      ],
    );
  }
}
