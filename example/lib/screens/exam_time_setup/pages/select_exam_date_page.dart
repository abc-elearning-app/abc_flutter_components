import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/src/widgets/custom_datetime_picker/custom_date_picker.dart';

class SelectExamDatePage extends StatelessWidget {
  final String title;
  final Widget image;
  final Map<String, dynamic> selectedTime;
  final PageController pageController;

  const SelectExamDatePage(
      {super.key,
      required this.title,
      required this.image,
      required this.pageController,
      required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: image,
          ),
          Expanded(child: CustomDatePicker(onSelectDate: (date) {
            selectedTime['exam_date'] = date.toIso8601String();
          }))
        ],
              ),
            ));
  }
}
