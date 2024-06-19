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
  final bool isDarkMode;

  final Color mainColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color beginnerBackgroundColor;
  final Color intermediateBackgroundColor;
  final Color advancedBackgroundColor;

  final void Function(int index) onImprove;

  const ProgressSection(
      {super.key,
      required this.isDarkMode,
      required this.progressList,
      required this.beginnerColor,
      required this.intermediateColor,
      required this.advancedColor,
      required this.mainColor,
      required this.onImprove,
      required this.beginnerBackgroundColor,
      required this.intermediateBackgroundColor,
      required this.advancedBackgroundColor});

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
          borderRadius: BorderRadius.circular(16),
          color: Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
          boxShadow: !isDarkMode
              ? [
                  BoxShadow(
                      color: Colors.grey.shade300,
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(0, 1))
                ]
              : null),
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
                        backgroundColor: _getBackgroundColor(data.progress),
                        icon: 'assets/images/${data.icon}.svg',
                        size: 35),

                    // Title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          data.title,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black,
                              overflow: TextOverflow.ellipsis),
                        ),
                      ),
                    ),

                    // Progress
                    Text('${data.progress.toInt()}%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ))
                  ],
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(
                  value: data.progress / 100,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(10),
                  color: _getColor(data.progress),
                  backgroundColor: isDarkMode
                      ? Colors.white.withOpacity(0.12)
                      : Colors.grey.shade200,
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

  Color _getBackgroundColor(double progress) {
    if (progress < 10) return beginnerBackgroundColor;
    if (progress >= 90) return advancedBackgroundColor;
    return intermediateBackgroundColor;
  }
}
