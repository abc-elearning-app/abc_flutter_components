import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/icon_box.dart';

class ProgressTileData {
  final String title;
  final double progress;
  final String icon;

  ProgressTileData(
      {required this.title, required this.progress, required this.icon});
}

class ProgressSection extends StatelessWidget {
  final List<ProgressTileData> progressList;

  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color mainColor;

  final void Function(int index) onImprove;

  const ProgressSection(
      {super.key,
      required this.progressList,
      required this.beginnerColor,
      required this.intermediateColor,
      required this.advancedColor,
      required this.mainColor,
      required this.onImprove});

  @override
  Widget build(BuildContext context) {
    progressList.sort((a, b) => a.progress <= b.progress ? 0 : 1);
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: progressList.length,
        itemBuilder: (context, index) =>
            _buildTile(context, progressList[index], index));
  }

  Widget _buildTile(BuildContext context, ProgressTileData data, int index) {
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
      padding: const EdgeInsets.all(15),
      width: double.infinity,
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
                        iconColor: _getColor(data.progress),
                        backgroundColor:
                            _getColor(data.progress).withOpacity(0.2),
                        icon: 'assets/images/${data.icon}.svg'),

                    // Title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          data.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),

                    // Progress
                    Text('${data.progress.toInt()}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: data.progress / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  color: _getColor(data.progress),
                  backgroundColor: Colors.grey.shade200,
                )
              ],
            ),
          )),

          // Improve button
          _buildButton(index)
        ],
      ),
    );
  }

  Widget _buildButton(int index) => Transform.scale(
        scale: 0.8,
        child: MainButton(
          title: 'Improve',
          borderRadius: 20,
          textStyle: const TextStyle(fontSize: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          backgroundColor: mainColor.withOpacity(0.2),
          textColor: mainColor,
          onPressed: () => onImprove(index),
        ),
      );

  Color _getColor(double progress) {
    if (progress < 10) return beginnerColor;
    if (progress >= 90) return advancedColor;
    return intermediateColor;
  }
}
