import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class IconBox extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  final String icon;
  final double size;
  final EdgeInsets padding;
  final double borderRadius;

  const IconBox({
    super.key,
    required this.iconColor,
    required this.backgroundColor,
    required this.icon,
    this.size = 30,
    this.padding = const EdgeInsets.all(5),
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        padding: padding,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadius)),
        child: IconWidget(icon: icon, color: iconColor));
  }
}
