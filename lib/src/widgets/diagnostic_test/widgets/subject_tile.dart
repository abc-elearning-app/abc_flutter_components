import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectTile extends StatelessWidget {
  final String title;
  final String icon;
  final double progress;
  final Color color;
  final Color boxColor;

  const SubjectTile(
      {super.key,
      required this.title,
      required this.icon,
      required this.progress,
      required this.color,
      required this.boxColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 1,
              offset: const Offset(0, 1))
        ],
        borderRadius: BorderRadius.circular(15),
        color: boxColor,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: color.withOpacity(0.3),
                ),
                child: SvgPicture.asset(
                  icon,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),

              // Title
              Expanded(
                  child: Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    overflow: TextOverflow.ellipsis),
              )),
              Text(
                '${progress.toInt()}%',
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
              )
            ],
          ),

          // Progress
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              children: List.generate(
                  10,
                  (index) => Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: index < progress / 10
                                  ? color
                                  : Colors.grey.shade200),
                        ),
                      )),
            ),
          ),

          // Level
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                _getLevelIcon(),
                color: color,
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 5),
              Text(
                _getLevelTitle(),
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          )
        ],
      ),
    );
  }

  _getLevelIcon() {
    if (progress < 20) {
      return 'assets/images/beginner.svg';
    } else if (progress < 80) {
      return 'assets/images/intermediate.svg';
    } else {
      return 'assets/images/advanced.svg';
    }
  }

  _getLevelTitle() {
    if (progress < 20) {
      return 'Beginner';
    } else if (progress < 80) {
      return 'Intermediate';
    } else {
      return 'Advanced';
    }
  }
}
