import 'package:flutter/material.dart';

import 'floating_icons.dart';
import 'premium_icon.dart';

class PremiumButton extends StatelessWidget {
  final double buttonHeight;
  final List<Color> gradientColors;
  final EdgeInsets? margin;

  final bool isDarkMode;

  final String circleIcon;
  final String dnaIcon;
  final String starIcon;
  final String triangleIcon;
  final String premiumIcon;
  final String premiumBackground;

  final void Function() onClick;

  const PremiumButton({
    super.key,
    this.margin,
    this.gradientColors = const [Color(0xFFFF9840), Color(0xFFFF544E)],
    required this.buttonHeight,
    required this.isDarkMode,
    required this.onClick,
    required this.circleIcon,
    required this.dnaIcon,
    required this.starIcon,
    required this.triangleIcon, required this.premiumIcon, required this.premiumBackground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration:
      BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(
            color: isDarkMode ? Colors.black : Colors.grey.shade300,
            blurRadius: 2,
            spreadRadius: 2)
      ]),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(alignment: Alignment.center, children: [
          // Background colors
          Container(
              height: buttonHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: gradientColors),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 2,
                        blurRadius: 2)
                  ])),

          // Floating icons
          FloatingAnimation(
            buttonHeight: buttonHeight,
            circleIcon: circleIcon,
            dnaIcon: dnaIcon,
            starIcon: starIcon,
            triangleIcon: triangleIcon,
          ),

          // Button
          SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onClick,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
              child: Transform.translate(
                offset: const Offset(-20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PremiumIcon(
                      premiumIcon: premiumIcon,
                      premiumBackground: premiumBackground,
                    ),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                            style:
                            TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                            children: [
                              TextSpan(
                                  text: 'Upgrade',
                                  style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: ' to the Premium'),
                            ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}
