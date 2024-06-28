import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeIcon extends StatelessWidget {
  final String icon;
  final Color tileColor;
  const HomeIcon({super.key, required this.icon, required this.tileColor});

  @override
  Widget build(BuildContext context) {
    if(icon.endsWith(".svg")) {
      return SvgPicture.asset(
        icon,
        width: 40,
        color: tileColor,
      );
    }
    return Image.asset(
      icon,
      width: 40,
      color: tileColor,
    );
  }
}