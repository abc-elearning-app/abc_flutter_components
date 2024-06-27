import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/sad_effect.dart';
import 'package:lottie/lottie.dart';

import '../../animations/sprinkle_effect.dart';
import 'widgets/main_result_box.dart';

enum ResultType { fail, normal, pass }

class FinalTestResult extends StatelessWidget {
  final bool isFirstTime;
  final double progress;
  final int correctQuestions;
  final int incorrectQuestions;
  final double averageProgress;
  final List<ProgressTileData> progressList;

  final String doneImage;
  final String doneImageDark;
  final String failImage;
  final String failImageDark;
  final String reviseImage;
  final String reviseImageDark;

  final Color correctColor;
  final Color incorrectColor;
  final Color mainColor;
  final Color backgroundColor;
  final Color beginnerColor;
  final Color intermediateColor;
  final Color advancedColor;
  final Color beginnerBackgroundColor;
  final Color intermediateBackgroundColor;
  final Color advancedBackgroundColor;

  final bool isPro;
  final bool isDarkMode;
  final double passPercent;

  final void Function() onReviewAnswer;
  final void Function() onTryAgain;
  final void Function() onContinue;
  final void Function(int index) onImproveSubject;

  const FinalTestResult({
    super.key,
    required this.isFirstTime,
    required this.progress,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.averageProgress,
    required this.progressList,
    this.isPro = false,
    this.correctColor = const Color(0xFF0BE5B1),
    this.incorrectColor = const Color(0xFFF14A4A),
    this.mainColor = const Color(0xFFE3A651),
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.beginnerColor = const Color(0xFFFC5656),
    this.intermediateColor = const Color(0xFFFF9669),
    this.advancedColor = const Color(0xFF2C9CB5),
    this.beginnerBackgroundColor = const Color(0xFFFDD7D7),
    this.intermediateBackgroundColor = const Color(0xFFFFEEE7),
    this.advancedBackgroundColor = const Color(0xFFD3F7FF),
    required this.onReviewAnswer,
    required this.onTryAgain,
    required this.onContinue,
    required this.onImproveSubject,
    required this.isDarkMode,
    this.doneImage = 'assets/images/final_test_done.json',
    this.doneImageDark = 'assets/images/final_test_done_dark.json',
    this.failImage = 'assets/images/final_test_dail.json',
    this.failImageDark = 'assets/images/final_test_fail_dark.json',
    this.reviseImage = 'assets/images/final_test_revise.json',
    this.reviseImageDark = 'assets/images/final_test_revise_dark.json',
    this.passPercent = 80,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildImage(),

                  // General result and progress box
                  MainResultBox(
                    passPercent: passPercent,
                    isFirstTime: isFirstTime,
                    isPro: isPro,
                    isDarkMode: isDarkMode,
                    progress: progress,
                    incorrectQuestions: incorrectQuestions,
                    correctQuestions: correctQuestions,
                    averageProgress: averageProgress,
                    mainColor: mainColor,
                    correctColor: correctColor,
                    incorrectColor: incorrectColor,
                  ),

                  Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      width: double.infinity,
                      child: _buildButton(
                        false,
                        'Review My Answers',
                        mainColor,
                        onReviewAnswer,
                      )),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Text('Test Subjects',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black)),
                    ),
                  ),
                  ProgressSection(
                    progressList: progressList,
                    mainColor: mainColor,
                    isDarkMode: isDarkMode,
                    beginnerColor: beginnerColor,
                    intermediateColor: intermediateColor,
                    advancedColor: advancedColor,
                    onImprove: onImproveSubject,
                    beginnerBackgroundColor: beginnerBackgroundColor,
                    intermediateBackgroundColor: intermediateBackgroundColor,
                    advancedBackgroundColor: advancedBackgroundColor,
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
      ),
    );
  }

  Widget _buildImage() => Stack(alignment: Alignment.bottomCenter, children: [
        if (isFirstTime && progress >= passPercent)
          const SprinkleEffect(additionalOffsetY: -100),
        Transform.translate(
            offset: Offset(0, isFirstTime ? 20 : 0),
            child: Transform.scale(
              scale: isFirstTime ? 1.2 : 1,
              child: Lottie.asset(
                _getImagePath(),
                height: isFirstTime ? 250 : 180,
              ),
            )),
        if (isFirstTime && progress < passPercent) const SadEffect(),
      ]);

  Widget _buildButton(
    bool isSelected,
    String title,
    Color buttonMainColor,
    void Function() action,
  ) =>
      Container(
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: MainButton(
          title: title,
          backgroundColor: isSelected
              ? buttonMainColor
              : Colors.white.withOpacity(isDarkMode ? 0.16 : 1),
          borderSize: BorderSide(width: 1, color: buttonMainColor),
          textColor: isSelected ? Colors.white : buttonMainColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
          borderRadius: 18,
          onPressed: action,
        ),
      );

  _getImagePath() {
    String path = 'assets/images/';
    if (isFirstTime) {
      if (progress >= 80) {
        path += 'final_test_done';
      } else {
        path += 'final_test_fail';
      }
    } else {
      path += 'final_test_revise';
    }

    if (isDarkMode) {
      path += '_dark.json';
    } else {
      path += '.json';
    }

    return path;
  }
}
