import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class FinalTestBoxComponent extends StatelessWidget {
  final String icon;
  final String background;

  final Color mainColor;
  final Color secondaryColor;
  final Color correctColor;
  final Color incorrectColor;

  final bool isDarkMode;

  final double progress;
  final double correctPercent;
  final double minPassValue;

  final bool isDone;

  final void Function() onClickFinal;

  const FinalTestBoxComponent({
    super.key,
    required this.icon,
    required this.background,
    required this.mainColor,
    required this.correctPercent,
    required this.progress,
    required this.isDarkMode,
    required this.secondaryColor,
    required this.onClickFinal,
    required this.minPassValue,
    required this.isDone,
    this.correctColor = const Color(0xFF15CB9F),
    this.incorrectColor = const Color(0xFFFC5656),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClickFinal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(background),
              fit: BoxFit.cover,
            ),
            boxShadow: !isDarkMode ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2, offset: const Offset(0, 1))] : null,
            borderRadius: BorderRadius.circular(15)),
        child: Stack(children: [
          Positioned.fill(
              child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), gradient: _gradientColors()),
          )),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 10),
                      child: IconWidget(icon: icon, height: 80),
                    ),
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Text('Our final test is the ultimate gauge that assesses your readiness for the actual exam.',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            )),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: _buildLinearProgress(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_getResultText(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                    progress == 0
                        ? const Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: Icon(Icons.arrow_forward, color: Colors.white),
                          )
                        : RichText(
                            text: TextSpan(style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white), children: [
                            TextSpan(
                              text: (isDone ? correctPercent : progress).toInt().toString(),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            TextSpan(text: '% ${_getProgressText()}', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)))
                          ]))
                  ],
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildLinearProgress() => LinearPercentIndicator(
        padding: EdgeInsets.zero,
        percent: (isDone ? correctPercent : progress) / 100,
        animation: true,
        barRadius: const Radius.circular(20),
        lineHeight: 10,
        progressColor: isDone ? correctColor : mainColor,
        backgroundColor: isDone ? incorrectColor : Colors.grey.shade200.withOpacity(0.3),
      );

  _getResultText() {
    if (progress == 0) return 'Start';
    if (isDone) {
      if (correctPercent >= minPassValue) return 'Passed';
      return 'Failed';
    }
    return 'Continue';
  }

  _getProgressText() => isDone ? 'Correct' : 'Answered';

  _gradientColors() => LinearGradient(
      colors: isDarkMode ? [const Color(0xFF292929).withOpacity(0.8), const Color(0xFF292929)] : [secondaryColor.withOpacity(0.8), secondaryColor],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
}
