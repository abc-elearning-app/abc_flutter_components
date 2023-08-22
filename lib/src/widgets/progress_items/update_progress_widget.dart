import 'package:flutter/material.dart';

class UpdateProgressWidget extends StatelessWidget {
  final ValueNotifier<int> updateUserDataValueNotifier;
  final Color textColor;

  const UpdateProgressWidget({
    super.key,
    required this.updateUserDataValueNotifier,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: updateUserDataValueNotifier,
      builder: (context, value, child) {
        return Text(
          "${value * 10}%",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: textColor,
          ),
        );
      },
    );
  }
}
