import 'package:flutter/material.dart';

import '../../custom_datetime_picker/custom_time_picker.dart';

class SelectReminderTimePage extends StatelessWidget {
  final String title;
  final String image;
  final bool isDarkMode;

  final void Function(TimeOfDay selectedTime) onSelectTime;

  const SelectReminderTimePage({
    super.key,
    required this.title,
    required this.image,
    required this.onSelectTime,
    required this.isDarkMode,
  });

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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.white : Colors.black),
              textAlign: TextAlign.center,
            ),
          ),

          // Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Image.asset(image, height: 280),
          ),
          Expanded(
              child: Transform.scale(
                  scale: 1.1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: CustomTimePicker(onSelectTime: onSelectTime),
                  )))
        ],
      ),
    ));
  }
}
