import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuButtonGetPro extends StatelessWidget {
  final VoidCallback onPress;

  const MenuButtonGetPro({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primary.withGreen(200),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        SvgPicture.asset("assets/static/icons/crown_icon.svg",
            width: 24, height: 24, color: Colors.white),
        const Text(
          "Get Pro",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              letterSpacing: 0.02 * 16),
        )
      ]),
    );
  }
}
