import 'package:flutter/material.dart';

import '../../custom_datetime_picker/custom_time_picker.dart';


class SelectReminderTimePage extends StatelessWidget {
  final String title;
  final Widget image;
  final Map<String, dynamic> selectedTime;
  final PageController pageController;

  const SelectReminderTimePage(
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
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: image,
          ),
          Expanded(
              child: Transform.scale(
                  scale: 1.2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: CustomTimePicker(
                      onSelectTime: (TimeOfDay selectedReminderTime) {
                        selectedTime['reminder_hour'] = selectedReminderTime.hour.toString();
                        selectedTime['reminder_minute'] = (selectedReminderTime.minute + 1).toString();
                      },
                    ),
                  )))
        ],
      ),
    ));
  }
}
