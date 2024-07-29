import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'half_circle_progress.dart';

class MainResultBox extends StatefulWidget {
  final bool isFirstTime;
  final bool isDarkMode;

  final Color mainColor;
  final Color correctColor;
  final Color incorrectColor;

  final double passPercent;
  final double progress;
  final double averageProgress;
  final int correctQuestions;
  final int incorrectQuestions;

  final String bannerShapeImage;

  const MainResultBox({
    super.key,
    required this.isDarkMode,
    this.correctColor = const Color(0xFF0BE5B1),
    this.incorrectColor = const Color(0xFFF14A4A),
    required this.progress,
    required this.averageProgress,
    required this.correctQuestions,
    required this.incorrectQuestions,
    required this.mainColor,
    required this.isFirstTime,
    required this.passPercent,
    required this.bannerShapeImage,
  });

  @override
  State<MainResultBox> createState() => _MainResultBoxState();
}

class _MainResultBoxState extends State<MainResultBox> {
  bool isShowingDetail = false;

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        margin: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(widget.isDarkMode ? 0.16 : 1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.isFirstTime) _buildMessage(),

            if (!widget.isFirstTime) const SizedBox(height: 10),

            // Progress chart
            HalfCircleProgressIndicator(
              correctColor: widget.correctColor,
              incorrectColor: widget.incorrectColor,
              progress: widget.progress / 100,
              lineWidth: 20,
              radius: 125,
              center: Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: RichText(
                  text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                            color: widget.progress < 0.8 ? widget.incorrectColor : widget.correctColor,
                            fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(text: '${widget.progress.round()}', style: const TextStyle(fontSize: 70)),
                        const TextSpan(text: '%', style: TextStyle(fontSize: 40))
                      ]),
                ),
              ),
            ),

            // Chart explanation
            _buildExplanation(),

            // Linear progress
            if (widget.isFirstTime) _buildLinearProgress(context),

            // Average community score
            if (widget.isFirstTime)
              Text(
                'Community Score: ${widget.averageProgress.toInt()}% ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: widget.isDarkMode ? Colors.white : Colors.black),
              )
          ],
        ),
      ),

      // Top banner
      if (widget.isFirstTime) _buildBanner(),
    ]);
  }

  Widget _buildMessage() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Text(
          widget.progress >= widget.passPercent
              ? "Do not rest on your laurels, friend. Time to leaf through the rest of these tests and make them tremble with your intellect!"
              : "That was a tough one, but every wrong answer is a stepping stone to the right one. Keep at it, and you'll be a knowledge ninja soon!",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Color.lerp(widget.progress >= widget.passPercent ? widget.correctColor : widget.incorrectColor, Colors.black, widget.isDarkMode ? 0 : 0.2),
              fontSize: 14),
          textAlign: TextAlign.center,
        ),
      );

  Widget _buildExplanation() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _colorExplanation(widget.correctColor, 'Correct', widget.correctQuestions),
            _colorExplanation(widget.incorrectColor, 'Incorrect', widget.incorrectQuestions),
          ],
        ),
      );

  Widget _colorExplanation(Color color, String title, int questionNum) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Color line
          Container(
            width: 25,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, color: Color(0xFF939393)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  '$questionNum ${'Questions'}',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: widget.isDarkMode ? Colors.white : Colors.black),
                ),
              )
            ],
          )
        ],
      );

  Widget _buildLinearProgress(BuildContext context) => Stack(alignment: Alignment.center, children: [
        const SizedBox(height: 50),

        // Background
        LinearPercentIndicator(
          backgroundColor: widget.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          lineHeight: 9,
          barRadius: const Radius.circular(8),
        ),

        // Main progress
        LinearPercentIndicator(
          backgroundColor: Colors.transparent,
          percent: widget.progress / 100,
          progressColor: widget.mainColor,
          lineHeight: 12,
          animation: true,
          barRadius: const Radius.circular(8),
        ),

        // Average point
        Positioned(
            left: MediaQuery.of(context).size.width * 0.0075 * widget.averageProgress,
            child: CircleAvatar(
              radius: 9,
              backgroundColor: Colors.grey.withOpacity(0.3),
              child: const CircleAvatar(
                radius: 5,
                backgroundColor: Colors.white,
              ),
            ))
      ]);

  Widget _buildBanner() => Transform.translate(
        offset: const Offset(0, -25),
        child: Stack(alignment: Alignment.center, children: [
          IconWidget(
            icon: widget.bannerShapeImage,
            height: 50,
            color: widget.progress >= widget.passPercent ? widget.correctColor : Color.lerp(widget.incorrectColor, Colors.white, 0.8)!,
          ),
          Text(
            widget.progress >= widget.passPercent ? 'Excellent Performance!' : 'Not Enough To Pass!',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: widget.progress >= widget.passPercent ? Colors.white : widget.incorrectColor,
            ),
          ),
        ]),
      );
}
