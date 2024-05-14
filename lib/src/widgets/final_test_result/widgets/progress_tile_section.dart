import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';

import '../../../constants/app_strings.dart';

class ProgressTileData {
  final String title;
  final int progress;
  final Color color;

  ProgressTileData(
      {required this.title, required this.progress, required this.color});
}

class ProgressSection extends StatelessWidget {
  const ProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    List<ProgressTileData> progressList = [
      ProgressTileData(
          title: 'Engineering Comprehension',
          progress: 40,
          color: const Color(0xFFFC5656)),
      ProgressTileData(
          title: 'Arithmetic Comprehension',
          progress: 60,
          color: const Color(0xFFFF9669)),
      ProgressTileData(
          title: 'Mechanical Comprehension',
          progress: 80,
          color: const Color(0xFF2C9CB5)),
    ];

    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: progressList.length,
        itemBuilder: (context, index) => _buildTile(
            context,
            progressList[index].title,
            progressList[index].progress,
            progressList[index].color));
  }

  Widget _buildTile(
      BuildContext context, String title, int progress, Color color) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade300,
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 1))
          ]),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: [
          Expanded(
              child: Container(
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconBox(
                        iconColor: const Color(0xFFFC5656),
                        backgroundColor:
                            const Color(0xFFFC5656).withOpacity(0.2),
                        icon: 'assets/images/subject_icon_0.svg'),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),
                    Text('$progress%', style: const TextStyle(fontSize: 16))
                  ],
                ),
                LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  color: color,
                  backgroundColor: Colors.grey.shade200,
                )
              ],
            ),
          )),
          Transform.scale(
            scale: 0.9,
            child: MainButton(
              title: 'Improve',
              borderRadius: 20,
              textStyle: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              backgroundColor: const Color(0xFFE3A651).withOpacity(0.2),
              textColor: const Color(0xFFE3A651),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
