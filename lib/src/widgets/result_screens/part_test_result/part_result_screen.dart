import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/sprinkle_effect.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/part_test_result/widgets/circular_progress_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/part_test_result/widgets/linear_progress_box.dart';

import '../../../../flutter_abc_jsc_components.dart';

class PartResultScreen extends StatelessWidget {
  final int partIndex;
  final int correctQuestions;
  final int totalQuestions;
  final double passingProbability;
  final double improvedPercent;

  final Color backgroundColor;
  final Color boxBackgroundColor;
  final Color buttonBackgroundColor;
  final Color correctColor;
  final Color incorrectColor;
  final Color mainColor;
  final Color secondaryColor;

  final String passIcon;
  final String defaultIcon;
  final String failIcon;

  final void Function() onTryAgain;
  final void Function() onContinue;

  const PartResultScreen({
    super.key,
    required this.partIndex,
    required this.correctQuestions,
    required this.totalQuestions,
    required this.passingProbability,
    required this.improvedPercent,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.boxBackgroundColor = const Color(0xFFF3F1E5),
    this.buttonBackgroundColor = Colors.white,
    this.correctColor = const Color(0xFF38EFAE),
    this.incorrectColor = const Color(0xFFF14A4A),
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    required this.onTryAgain,
    required this.onContinue,
    this.passIcon = 'assets/images/final_test_pass.png',
    this.defaultIcon = 'assets/images/final_test_default.png',
    this.failIcon = 'assets/images/final_test_fail.png',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Title
                      Text('Part ${partIndex + 1} Completed!',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w600)),
                  
                      // Detail
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          'Time for a dance break! (Disclaimer: App is not responsible for any injuries sustained during spontaneous dance celebrations.)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ),
                  
                      // Image
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Image.asset(_getImagePath()),
                      ),
                  
                      CircularProgressBox(
                          backgroundColor: boxBackgroundColor,
                          correctQuestions: correctQuestions,
                          totalQuestions: totalQuestions,
                          correctColor: correctColor,
                          incorrectColor: incorrectColor,
                          progressTextColor: secondaryColor),
                  
                      LinearProgressBox(
                        passingProbability: passingProbability,
                        improvedPercent: improvedPercent,
                        backgroundColor: secondaryColor,
                        progressColor: mainColor,
                        improveColor: correctColor,
                      ),
                    ],
                  ),
                ),
              ),

              // Buttons
              _buildButtonRow(),
            ],
          ),
        ),
        
        // Pass effect
        if (correctQuestions / totalQuestions >= 0.8)
          IgnorePointer(
              child: SprinkleEffect(
            height: MediaQuery.of(context).size.height / 2,
            additionalOffsetY: -150,
            speed: 5,
            rows: 5,
          ))
      ]),
    );
  }

  Widget _buildButtonRow() => Row(
        children: [
          Expanded(child: _button(false, 'Try Again', mainColor, onTryAgain)),
          Expanded(child: _button(true, 'Continue', mainColor, onContinue)),
        ],
      );

  Widget _button(bool isSelected, String title, Color buttonMainColor,
          void Function() action) =>
      Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 25, top: 10),
        child: MainButton(
          title: title,
          backgroundColor: isSelected ? buttonMainColor : buttonBackgroundColor,
          borderSize: BorderSide(width: 1, color: buttonMainColor),
          textColor: isSelected ? buttonBackgroundColor : buttonMainColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
          borderRadius: 18,
          onPressed: action,
        ),
      );

  _getImagePath() {
    if (correctQuestions / totalQuestions <= 0.1) {
      return failIcon;
    } else if (correctQuestions / totalQuestions >= 0.8) {
      return passIcon;
    } else {
      return defaultIcon;
    }
  }
}
