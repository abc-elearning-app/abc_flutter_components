import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class EndTestButton extends StatelessWidget {
  final VoidCallback onTap;

  const EndTestButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withOpacity(0.12)
                    : const Color(0xFF212121).withOpacity(0.08),
                borderRadius: BorderRadius.circular(40)),
            child: Text(
              AppStrings.gameStrings.gameButtonSubmit,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white
                    : const Color(0xFF212121),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
