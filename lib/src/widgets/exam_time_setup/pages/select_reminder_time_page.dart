import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../custom_datetime_picker/custom_time_picker.dart';

class SelectReminderTimePage extends StatelessWidget {
  final String title;
  final Widget image;
  final bool showBackButton;
  final Map<String, dynamic> selectedTime;
  final PageController pageController;

  const SelectReminderTimePage(
      {super.key,
      required this.title,
      required this.image,
      required this.pageController,
      required this.selectedTime,
      required this.showBackButton});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Title
          Stack(alignment: Alignment.center, children: [
            if (showBackButton)
              Align(
                alignment: Alignment.centerLeft,
                child: Transform.translate(
                  offset: const Offset(-15, 0),
                  child: IconButton(
                      onPressed: () => pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut),
                      icon: const Icon(
                        Icons.chevron_left,
                        size: 30,
                      )),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ]),

          // Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: image,
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
