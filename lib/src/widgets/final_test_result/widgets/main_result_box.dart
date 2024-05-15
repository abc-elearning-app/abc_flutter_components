import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../flutter_abc_jsc_components.dart';
import '../../animations/blur_effect.dart';
import 'half_circle_progress.dart';

class MainResultBox extends StatelessWidget {
  final ValueNotifier<bool> isProPurchased;

  final Color correctColor;
  final Color incorrectColor;

  final double progress;
  final double averageProgress;
  final int correctQuestions;
  final int incorrectQuestions;

  MainResultBox(
      {super.key,
      required this.isProPurchased,
      this.correctColor = const Color(0xFF28D799),
      this.incorrectColor = const Color(0xFFF14A4A),
      required this.progress,
      required this.averageProgress,
      required this.correctQuestions,
      required this.incorrectQuestions});

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
            // Result title
            _buildDetailText(),

            // Progress chart
            Stack(children: [
              Column(
                children: [
                  // Chart
                  HalfCircleProgressIndicator(
                      value: progress / 100, lineWidth: 20, radius: 125),

                  // Chart explanation
                  _buildExplanation(),

                  // Linear progress
                  _buildLinearProgress(context),

                  // Average community progress
                  _buildCommunityScore()
                ],
              ),

              // Blur effect and buttons (when not purchased)
              // ValueListenableBuilder(
              //     valueListenable: isProPurchased,
              //     builder: (_, value, __) =>
              //         Visibility(visible: !value, child: const BlurEffect())),
              // ValueListenableBuilder(
              //     valueListenable: isProPurchased,
              //     builder: (_, value, __) => Visibility(
              //         visible: !value,
              //         child: Positioned(
              //             top: 10,
              //             left: 10,
              //             child: _proContentNotification(context)))),
              // ValueListenableBuilder(
              //     valueListenable: isProPurchased,
              //     builder: (_, value, __) => Visibility(
              //         visible: !value,
              //         child: Align(
              //           alignment: Alignment.center,
              //           child: _seeFullButton(),
              //         )))
            ])
          ],
        ),
      ),
      _buildBanner(),
    ]);
  }

  Widget _buildDetailText() => progress >= 90 || progress < 20
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
            margin: const EdgeInsets.only(top: 5),
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

        // Background, use gap to align
        LinearPercentIndicator(
          backgroundColor: Colors.grey.shade200,
          lineHeight: 9,
          barRadius: const Radius.circular(8),
        ),

        // Main progress
        LinearPercentIndicator(
          backgroundColor: Colors.transparent,
          percent: progress / 100,
          progressColor: const Color(0xFFE3A651),
          lineHeight: 12,
          animation: true,
          barRadius: const Radius.circular(8),
        ),

        // Average point
        Positioned(
            left: MediaQuery.of(context).size.width *
                0.82 *
                averageProgress /
                100,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.grey.withOpacity(0.3),
              child: const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.white,
              ),
            ))
      ]);

  Widget _buildBanner() => progress >= 90 || progress < 20
      ? Transform.translate(
          offset: const Offset(0, -25),
          child: Stack(alignment: Alignment.center, children: [
            SvgPicture.asset(
              'assets/images/banner_shape.svg',
              height: 50,
              colorFilter: ColorFilter.mode(
                  progress >= 90
                      ? correctColor
                      : Color.lerp(incorrectColor, Colors.white, 0.8) ??
                          incorrectColor,
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

  Widget _proContentNotification(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width * 0.24,
        height: 20,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10), color: Colors.black),
        child: SvgPicture.asset('assets/images/pro_content.svg'),
      );

  Widget _seeFullButton() => Container(
      width: 150,
      height: 50,
      margin: const EdgeInsets.only(top: 120),
      decoration: BoxDecoration(
          // image: DecorationImage(image: AssetImage(''), fit: BoxFit.cover),
          borderRadius: BorderRadius.circular(30),
          color: Colors.green),
      child: MainButton(
        title: 'See Full',
        borderSize: const BorderSide(color: Colors.green, width: 2),
        borderRadius: 30,
        backgroundColor: Colors.transparent,
        onPressed: () {
          isProPurchased.value = true;
        },
      ));

  Widget _buildCommunityScore() => StatefulBuilder(
        builder: (_, setState) {
          return Column(
            children: [
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
              AnimatedContainer(
                height: isShowingDetail ? 100 : 0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      // color: context.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(15)),
                  child: const Text(
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

class TrianglePainter extends CustomPainter {
  final double borderRadius;

  TrianglePainter({required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // Calculate points
    final Offset topCenter = Offset(size.width / 2, borderRadius);
    final Offset bottomRight =
        Offset(size.width - borderRadius, size.height - borderRadius);
    final Offset bottomLeft = Offset(borderRadius, size.height - borderRadius);

    // Move to top center point
    path.moveTo(topCenter.dx, topCenter.dy);

    // Draw right side with rounded corner
    path.lineTo(size.width / 2, borderRadius);
    path.quadraticBezierTo(
        size.width, borderRadius, bottomRight.dx, bottomRight.dy);

    // Draw bottom side with rounded corner
    path.lineTo(bottomRight.dx, bottomRight.dy);
    path.quadraticBezierTo(
        size.width - borderRadius, size.height, bottomLeft.dx, bottomLeft.dy);

    // Draw left side with rounded corner
    path.lineTo(bottomLeft.dx, bottomLeft.dy);
    path.quadraticBezierTo(
        borderRadius, size.height, topCenter.dx, topCenter.dy);

    path.close();

    // Draw the filled triangle
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
