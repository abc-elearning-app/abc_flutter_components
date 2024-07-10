import 'package:flutter/material.dart';

class StartDiagnosticPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final String image;
  final bool isDarkMode;

  const StartDiagnosticPage({
    super.key,
    required this.title,
    required this.image,
    required this.subTitle,
    required this.isDarkMode,
  });

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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black),
                textAlign: TextAlign.center)),

        // Image
        Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Image.asset(image, height: 300)),

        // Subtitle
        Expanded(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(subTitle,
                  style: TextStyle(
                      fontSize: 16,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black),
                  textAlign: TextAlign.center)),
        )
      ],
    ));
  }
}
