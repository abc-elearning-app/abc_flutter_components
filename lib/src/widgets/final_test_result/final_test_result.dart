import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../animations/blur_effect.dart';
import 'widgets/buttons.dart';
import 'widgets/main_result_box.dart';
import 'widgets/progress_tile_section.dart';

class FinalTestResult extends StatelessWidget {
  FinalTestResult({super.key});

  final isProPurchased = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  // General result and progress box
                  Image.asset('assets/images/final_test_pass.png'),
                  MainResultBox(
                      isProPurchased: isProPurchased,
                      progress: 90,
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
                              padding: EdgeInsets.only(
                                  left: 15, top: 30, bottom: 10),
                              child: Text('Test Subjects',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
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
      ),
    );
  }
}
