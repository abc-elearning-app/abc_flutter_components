import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'floating_icons.dart';
import 'gif_icon.dart';

class PremiumButton extends StatelessWidget {
  final double buttonHeight;
  final List<Color> gradientColors;
  final void Function() onClick;
  final EdgeInsets? margin;

  const PremiumButton({
    super.key,
    required this.onClick,
    required this.gradientColors,
    required this.buttonHeight,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(15), boxShadow: [
        BoxShadow(color: Colors.grey.shade300, blurRadius: 2, spreadRadius: 2)
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
          FloatingAnimation(buttonHeight: buttonHeight),

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // GIF & Text
                  Transform.translate(
                      offset: const Offset(-15, 0), child: const GifIcon()),
                  Expanded(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                          style: TextStyle(fontFamily: 'Poppins', fontSize: 20),
                          children: [
                            TextSpan(
                                text: 'Upgrade',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' to the Premium'),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
