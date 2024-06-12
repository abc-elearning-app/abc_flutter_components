import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartDiagnosticPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final bool isDarkMode;
  final PageController pageController;

  const StartDiagnosticPage(
      {super.key,
      required this.title,
      required this.image,
      required this.subTitle,
      required this.pageController,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        // Title
        Padding(
            padding: const EdgeInsets.all(20),
            child: Text(title,
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black),
                textAlign: TextAlign.center)),

        // Image
        Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Image.asset(image)),

        // Subtitle
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(subTitle,
                style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black),
                textAlign: TextAlign.center))
      ],
    ));
  }
}
