import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stroke_text/stroke_text.dart';

class StreakScreen extends StatelessWidget {
  const StreakScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Streak',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: 250,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/streak_background.png'),
                      fit: BoxFit.cover)),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const StrokeText(
                            text: '12',
                            textStyle: TextStyle(
                              fontSize: 10,
                              color: Color(0xFFE3A651),
                            ),
                            strokeColor: Colors.white,
                            textScaler: TextScaler.linear(6),
                            strokeWidth: 6),
                        Transform.translate(
                          offset: const Offset(0, -10),
                          child: const StrokeText(
                              text: 'Day Streak',
                              textStyle: TextStyle(
                                fontSize: 20,
                                color: Color(0xFFE3A651),
                              ),
                              strokeColor: Colors.white,
                              strokeWidth: 3),
                        ),
                      ],
                    ),
                    SvgPicture.asset('assets/images/streak_fire.svg')
                  ],
                ),
              )),
          _buildTitle('Streak Challenge'),
          _buildTitle('May 2024'),
        ],
      ),
    );
  }

  _buildTitle(String title) => Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500
          ),
        ),
      );
}
