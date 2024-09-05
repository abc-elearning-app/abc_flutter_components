import 'package:flutter/material.dart';

class GetProIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool darkMode;
  final String proIcon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double width;
  final double height;

  const GetProIcon({
    super.key,
    this.onPressed,
    this.margin,
    this.padding,
    this.width = 80,
    this.height = 30,
    required this.darkMode,
    required this.proIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding ?? const EdgeInsets.all(4),
        margin: margin,
        decoration: BoxDecoration(color: darkMode ? Colors.white.withOpacity(0.24) : Colors.black, borderRadius: BorderRadius.circular(16)),
        child: Image.asset(proIcon, fit: BoxFit.contain),
      ),
    );
  }
}
