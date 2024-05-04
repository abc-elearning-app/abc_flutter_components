import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StartDiagnosticPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget image;
  final bool showBackButton;
  final PageController pageController;

  const StartDiagnosticPage(
      {super.key,
      required this.title,
      required this.image,
      required this.subTitle,
      required this.showBackButton,
      required this.pageController});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        // Title
        Stack(alignment: Alignment.center, children: [
          if (showBackButton)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut),
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 30,
                  )),
            ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ]),

        // Image
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: image,
        ),

        // Subtitle
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              subTitle,
              style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ))
      ],
    ));
  }
}
