import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

import '../../custom_datetime_picker/custom_time_picker.dart';

class SelectReminderTimePage extends StatelessWidget {
  final String title;
  final String image;
  final bool isDarkMode;
  final Map<String, dynamic> selectedTime;
  final PageController pageController;

  const SelectReminderTimePage(
      {super.key,
      required this.title,
      required this.image,
      required this.pageController,
      required this.selectedTime,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
          ),

          // Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: ImageWidget(icon: image, height: 300),
          ),
          Expanded(
              child: Transform.scale(
                  scale: 1.1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTimePicker(
                      onSelectTime: (TimeOfDay selectedReminderTime) {
                        selectedTime['reminder_hour'] =
                            selectedReminderTime.hour.toString();
                        selectedTime['reminder_minute'] =
                            (selectedReminderTime.minute + 1).toString();
                      },
                    ),
                  )))
        ],
      ),
    ));
  }
}
