import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/sad_effect.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/final_test_result/widgets/progress_tile_section.dart';

import '../../animations/sprinkle_effect.dart';
import 'widgets/main_result_box.dart';

enum ResultType { fail, normal, pass }

class FinalTestResult extends StatelessWidget {
  final double progress;
  final int correctQuestions;
  final int incorrectQuestions;
  final double averageProgress;
  final List<ProgressTileData> progressList;

  final Color correctColor;
  final Color incorrectColor;
  final Color mainColor;
  final Color backgroundColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color boxBackgroundColor;

  final bool isPro;

  final void Function() onReviewAnswer;
  final void Function() onTryAgain;
  final void Function() onContinue;
  final void Function(int index) onImproveSubject;

  const FinalTestResult(
      {super.key,
      required this.progress,
      required this.correctQuestions,
      required this.incorrectQuestions,
      required this.averageProgress,
      required this.progressList,
      this.isPro = false,
      this.correctColor = const Color(0xFF28D799),
      this.incorrectColor = const Color(0xFFF14A4A),
      this.mainColor = const Color(0xFFE3A651),
      this.backgroundColor = const Color(0xFFF5F4EE),
      this.beginnerColor = const Color(0xFFFC5656),
      this.intermediateColor = const Color(0xFFFF9669),
      this.advancedColor = const Color(0xFF2C9CB5),
      this.boxBackgroundColor = Colors.white,
      required this.onReviewAnswer,
      required this.onTryAgain,
      required this.onContinue,
      required this.onImproveSubject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            padding:
                EdgeInsets.only(top: progress <= 10 || progress >= 90 ? 0 : 80),
            child: Column(
              children: [
                _buildImage(),

                // General result and progress box
                MainResultBox(
                  isPro: isPro,
                  progress: progress,
                  incorrectQuestions: incorrectQuestions,
                  correctQuestions: correctQuestions,
                  averageProgress: averageProgress,
                  mainColor: mainColor,
                  boxColor: boxBackgroundColor,
                ),

                SizedBox(
                    width: double.infinity,
                    child: _buildButton(
                      false,
                      'Review My Answers',
                      _getReviewButtonColor(),
                      onReviewAnswer,
                    )),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 20, top: 20),
                    child: Text('Test Subjects',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500)),
                  ),
                ),
                ProgressSection(
                  progressList: progressList,
                  mainColor: mainColor,
                  boxColor: boxBackgroundColor,
                  beginnerColor: beginnerColor,
                  intermediateColor: intermediateColor,
                  advancedColor: advancedColor,
                  onImprove: onImproveSubject,
                ),
              ],
            ),
          )),

          // Buttons
          Row(
            children: [
              Expanded(
                  child: _buildButton(
                false,
                'Try Again',
                mainColor,
                onTryAgain,
              )),
              Expanded(
                  child: _buildButton(
                true,
                'Continue',
                mainColor,
                onContinue,
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildImage() => Stack(alignment: Alignment.bottomCenter, children: [
        // Add sprinkle effect when pass >= 90%
        if (progress >= 90) const SprinkleEffect(additionalOffsetY: -100),

        Image.asset(_getImagePath()),

        if (progress <= 10) const SadEffect(),
      ]);

  Widget _buildButton(bool isSelected, String title, Color buttonMainColor,
          void Function() action) =>
      Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 25, top: 10),
        child: MainButton(
          title: title,
          backgroundColor: isSelected ? buttonMainColor : Colors.white,
          borderSize: BorderSide(width: 1, color: buttonMainColor),
          textColor: isSelected ? Colors.white : buttonMainColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
          borderRadius: 18,
          onPressed: action,
        ),
      );

  _getImagePath() {
    const baseUrl = 'assets/images/final_test_';
    if (progress <= 10) {
      return '${baseUrl}fail.png';
    } else if (progress >= 90) {
      return '${baseUrl}pass.png';
    } else {
      return '${baseUrl}default.png';
    }
  }

  _getReviewButtonColor() {
    if (progress <= 10) return incorrectColor;
    if (progress >= 90) return Color.lerp(correctColor, Colors.black, 0.2)!;
    return mainColor;
  }
}
