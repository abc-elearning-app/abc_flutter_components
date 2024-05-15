import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/animations/sad_effect.dart';

import '../animations/blur_effect.dart';
import '../animations/sprinkle_effect.dart';
import 'widgets/buttons.dart';
import 'widgets/main_result_box.dart';
import 'widgets/progress_tile_section.dart';

class FinalTestResult extends StatelessWidget {
  final double progress;

  FinalTestResult({super.key, required this.progress});

  final isProPurchased = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(alignment: Alignment.bottomCenter, children: [
                  if (progress >= 90)
                    const SprinkleEffect(
                      height: 250,
                      additionalOffsetY: -100,
                      fallDirection: 80,
                    ),
                  Image.asset(
                      'assets/images/final_test_${progress < 20 ? 'fail' : 'pass'}.png'),
                  if (progress < 20) const SadEffect(),
                ]),

                // General result and progress box
                MainResultBox(
                    isProPurchased: isProPurchased,
                    progress: progress,
                    incorrectQuestions: 10,
                    correctQuestions: 90,
                    averageProgress: 65),

                // Review button and blur effect
                Stack(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          reviewButton(context),
                          const Padding(
                            padding:
                                EdgeInsets.only(left: 15, top: 30, bottom: 10),
                            child: Text('Test Subjects',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ),
                          const ProgressSection(),
                        ]),

                    // Blur effect if not purchased
                    ValueListenableBuilder(
                        valueListenable: isProPurchased,
                        builder: (_, value, __) => Visibility(
                            visible: !value, child: const BlurEffect())),
                  ],
                ),
              ],
            ),
          )),
          Row(
            children: [
              Expanded(child: tryAgainButton()),
              Expanded(child: continueButton()),
            ],
          )
        ],
      ),
    );
  }
}
