import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'half_circle_progress.dart';

class MainResultBox extends StatelessWidget {
  final bool isPro;

  final Color mainColor;
  final Color correctColor;
  final Color incorrectColor;

  final double progress;
  final double averageProgress;
  final int correctQuestions;
  final int incorrectQuestions;

  MainResultBox(
      {super.key,
      required this.isPro,
      this.correctColor = const Color(0xFF28D799),
      this.incorrectColor = const Color(0xFFF14A4A),
      required this.progress,
      required this.averageProgress,
      required this.correctQuestions,
      required this.incorrectQuestions,
      required this.mainColor});

  bool isShowingDetail = false;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildDetailText(),

            // Progress chart
            Stack(children: [
              Column(
                children: [
                  // Chart
                  HalfCircleProgressIndicator(
                    correctColor: correctColor,
                    incorrectColor: incorrectColor,
                    progress: progress / 100,
                    lineWidth: 20,
                    radius: 125,
                    center: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      child: RichText(
                        text: TextSpan(
                            style: DefaultTextStyle.of(context).style.copyWith(
                                color: progress < 0.8
                                    ? incorrectColor
                                    : correctColor,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: '${progress.round()}',
                                  style: const TextStyle(fontSize: 70)),
                              const TextSpan(
                                  text: '%', style: TextStyle(fontSize: 40))
                            ]),
                      ),
                    ),
                  ),

                  // Chart explanation
                  _buildExplanation(),

                  // Linear progress
                  _buildLinearProgress(context),

                  // Average community score
                  _buildCommunityScore()
                ],
              ),
            ])
          ],
        ),
      ),

      // Top banner
      _buildBanner(),
    ]);
  }

  Widget _buildDetailText() => progress >= 90 || progress <= 10
      ? Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Text(
            progress >= 90
                ? "Do not rest on your laurels, friend. Time to leaf through the rest of these tests and make them tremble with your intellect!"
                : "That was a tough one, but every wrong answer is a stepping stone to the right one. Keep at it, and you'll be a knowledge ninja soon!",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Color.lerp(
                    progress >= 90 ? correctColor : incorrectColor,
                    Colors.black,
                    0.2),
                fontSize: 15),
            textAlign: TextAlign.center,
          ),
        )
      : const SizedBox();

  Widget _buildExplanation() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorExplanation(correctColor, 'Correct', correctQuestions),
            _colorExplanation(incorrectColor, 'Incorrect', incorrectQuestions),
          ],
        ),
      );

  _colorExplanation(Color color, String title, int questionNum) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color line
          Container(
            width: 25,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, color: Color(0xFF939393)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '$questionNum ${'Questions'}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          )
        ],
      );

  Widget _buildLinearProgress(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        const SizedBox(height: 50),

        // Background
        LinearPercentIndicator(
          backgroundColor: Colors.grey.shade200,
          lineHeight: 9,
          barRadius: const Radius.circular(8),
        ),

        // Main progress
        LinearPercentIndicator(
          backgroundColor: Colors.transparent,
          percent: progress / 100,
          progressColor: mainColor,
          lineHeight: 12,
          animation: true,
          barRadius: const Radius.circular(8),
        ),

        // Average point
        Positioned(
            left: MediaQuery.of(context).size.width * 0.008 * averageProgress,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.grey.withOpacity(0.3),
              child: const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.white,
              ),
            ))
      ]);

  Widget _buildBanner() => progress >= 90 || progress <= 10
      ? Transform.translate(
          offset: const Offset(0, -25),
          child: Stack(alignment: Alignment.center, children: [
            SvgPicture.asset(
              'assets/images/banner_shape.svg',
              height: 50,
              colorFilter: ColorFilter.mode(
                  progress >= 90
                      ? correctColor
                      : Color.lerp(incorrectColor, Colors.white, 0.8)!,
                  BlendMode.srcIn),
            ),
            Text(
              progress >= 90 ? 'Excellent Performance!' : 'Not Enough To Pass!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: progress >= 90 ? Colors.white : incorrectColor,
              ),
            ),
          ]),
        )
      : const SizedBox();

  Widget _buildCommunityScore() => StatefulBuilder(
        builder: (_, setState) {
          return Column(
            children: [
              // Main title
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  'Community Score: ${averageProgress.toInt()}% ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () =>
                      setState(() => isShowingDetail = !isShowingDetail),
                  child: SvgPicture.asset(
                    'assets/images/info_icon.svg',
                    colorFilter: const ColorFilter.mode(
                        Color(0xFF212121), BlendMode.srcIn),
                  ),
                )
              ]),

              // Explanation
              AnimatedContainer(
                height: isShowingDetail ? 100 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                      'Never gonna give you up, Never gonna let you down, Never gonna run around and desert you, Never gonna make you cry, Never gonna say goodbye, Never gonna tell a lie and hurt you',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14)),
                ),
              )
            ],
          );
        },
      );
}
