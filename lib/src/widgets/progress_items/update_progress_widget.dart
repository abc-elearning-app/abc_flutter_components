import 'package:flutter/material.dart';

class UpdateProgressWidget extends StatelessWidget {
  final ValueNotifier<int> updateUserDataValueNotifier;

  const UpdateProgressWidget({
    super.key,
    required this.updateUserDataValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: updateUserDataValueNotifier,
      builder: (context, value, child) {
        return Text(
          "${value * 10}%",
          textDirection: TextDirection.ltr,
          style: const TextStyle(
            color: Colors.white,
          ),
        );
      },
    );
  }
}
