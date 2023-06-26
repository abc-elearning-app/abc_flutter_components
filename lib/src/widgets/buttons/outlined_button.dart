import 'package:flutter/material.dart';

class OutlineButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final VoidCallback onPressed;
  final RoundedRectangleBorder? shape;
  final Color? textColor;

  const OutlineButton({
    Key? key,
    required this.child,
    this.color,
    this.padding,
    required this.onPressed,
    this.shape,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: shape,
      padding: padding,
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      child: child,
    );
  }
}
