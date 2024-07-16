import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/sprinkle_effect.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/part_test_result/widgets/circular_progress_box.dart';
import 'package:flutter_abc_jsc_components/src/widgets/result_screens/part_test_result/widgets/linear_progress_box.dart';
import 'package:lottie/lottie.dart';

import '../../../../flutter_abc_jsc_components.dart';

class PartResultComponent extends StatefulWidget {
  final int partIndex;
  final int correctQuestions;
  final int totalQuestions;
  final double passingProbability;
  final double improvedPercent;

  final Color correctColor;
  final Color incorrectColor;
  final Color mainColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final Color boxBackgroundColor;

  final String passImage;

  final bool isDarkMode;

  final void Function() onTryAgain;
  final void Function() onContinue;

  const PartResultComponent({
    super.key,
    required this.partIndex,
    required this.correctQuestions,
    required this.totalQuestions,
    required this.passingProbability,
    required this.improvedPercent,
    this.backgroundColor = const Color(0xFFF5F4EE),
    this.correctColor = const Color(0xFF38EFAE),
    this.incorrectColor = const Color(0xFFF14A4A),
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.boxBackgroundColor = const Color(0xFFF3F1E5),
    required this.passImage,
    required this.onTryAgain,
    required this.onContinue,
    required this.isDarkMode,
  });

  @override
  State<PartResultComponent> createState() => _PartResultComponentState();
}

class _PartResultComponentState extends State<PartResultComponent>
    with SingleTickerProviderStateMixin {
  final congratulationTexts = <String>[
    "Now go forth and conquer your to-do list! Remember, procrastination is the enemy of progress.",
    "You've earned yourself a... virtual pat on the back! (Please note: Virtual pats may not be redeemable for actual pizza.)",
    "Time for a dance break! (Disclaimer: App is not responsible for any injuries sustained during spontaneous dance celebrations.)"
  ];

  @override
  Widget build(BuildContext context) {
    int textIndex = Random().nextInt(2);

    return Scaffold(
      backgroundColor:
          widget.isDarkMode ? Colors.black : widget.backgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor:
            widget.isDarkMode ? Colors.black : widget.backgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: widget.isDarkMode ? Colors.white : Colors.black),
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
                      Text('Part ${widget.partIndex} Completed!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),

                      // Detail
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 5,
                          right: 5,
                          top: 15,
                        ),
                        child: Text(
                          congratulationTexts[textIndex],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: widget.isDarkMode
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),

                      // Image
                      Lottie.asset(widget.passImage, height: 300),

                      CircularProgressBox(
                          isDarkMode: widget.isDarkMode,
                          backgroundColor: widget.boxBackgroundColor,
                          correctQuestions: widget.correctQuestions,
                          totalQuestions: widget.totalQuestions,
                          correctColor: widget.correctColor,
                          incorrectColor: widget.incorrectColor,
                          progressTextColor: widget.secondaryColor),

                      LinearProgressBox(
                        passingProbability: widget.passingProbability,
                        improvedPercent: widget.improvedPercent,
                        backgroundColor: widget.secondaryColor,
                        progressColor: widget.mainColor,
                        improveColor: widget.correctColor,
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
        IgnorePointer(
            child: Transform.translate(
          offset: const Offset(0, -50),
          child: const ConfettiEffect(),
        )),
      ]),
    );
  }

  Widget _buildButtonRow() => Row(
        children: [
          Expanded(
              child: _button(
            false,
            'Try Again',
            widget.onTryAgain,
          )),
          Expanded(
              child: _button(
            true,
            'Continue',
            widget.onContinue,
          )),
        ],
      );

  Widget _button(bool isSelected, String title, void Function() action) =>
      Container(
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 25, top: 10),
        child: MainButton(
          title: title,
          backgroundColor: isSelected
              ? widget.mainColor
              : Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
          borderSize: BorderSide(width: 1, color: widget.mainColor),
          textColor: isSelected ? Colors.white : widget.mainColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(fontSize: 16),
          borderRadius: 14,
          onPressed: action,
        ),
      );
}
