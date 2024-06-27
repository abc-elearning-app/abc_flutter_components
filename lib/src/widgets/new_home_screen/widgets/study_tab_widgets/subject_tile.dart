import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class SubjectTile extends StatelessWidget {
  final SubjectData subjectData;
  final Color tileColor;
  final VoidCallback onPressed;
  const SubjectTile({super.key, required this.subjectData, required this.tileColor, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: const Offset(0, 1),
                    spreadRadius: 1)
              ]),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tileColor.withOpacity(0.2),
                ),
                child: Transform.scale(
                  scale: 1.5,
                  child: subjectData.icon.endsWith(".svg") ? SvgPicture.asset(
                    subjectData.icon,
                    color: tileColor,
                    colorBlendMode: BlendMode.srcIn,
                    width: 24,
                    height: 24,
                    // colorFilter: ColorFilter.mode(tileColor, BlendMode.srcIn),
                  ) : Image.asset(
                    width: 24,
                    height: 24,
                    subjectData.icon,
                    color: tileColor,
                    colorBlendMode: BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subjectData.title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // Text(
                      //   _getLevelTitle(subjectData.progress),
                      //   style: TextStyle(
                      //       fontSize: 16,
                      //       color: tileColor),
                      // ),
                    ],
                  ),
                ),
              ),
              CircularPercentIndicator(
                animation: true,
                radius: 35,
                percent: subjectData.progress / 100,
                progressColor: tileColor,
                backgroundColor: tileColor.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
                lineWidth: 7,
                center: Text(
                  '${subjectData.progress.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  String _getLevelTitle(double progress) {
    if (progress < 40) {
      return 'Beginner';
    } else if (progress < 80) {
      return 'Intermediate';
    }
    return 'Advanced';
  }
}
