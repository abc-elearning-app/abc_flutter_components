import 'package:flutter/material.dart';

class GetProIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool darkMode;
  final String proIcon;
  final EdgeInsets? padding;
  final EdgeInsets? margin;

  const GetProIcon({
    super.key,
    this.onPressed,
    required this.darkMode,
    this.margin,
    this.padding,
    required this.proIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 30,
        padding: padding ?? const EdgeInsets.all(4),
        margin: margin,
        decoration: BoxDecoration(color: darkMode ? Colors.white.withOpacity(0.24) : Colors.black, borderRadius: BorderRadius.circular(16)),
        child: Image.asset(proIcon, fit: BoxFit.contain),
      ),
    );
  }
}
