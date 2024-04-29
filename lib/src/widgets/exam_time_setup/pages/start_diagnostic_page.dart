import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartDiagnosticPage extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget image;

  const StartDiagnosticPage(
      {super.key,
      required this.title,
      required this.image,
      required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: image,
        ),
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
