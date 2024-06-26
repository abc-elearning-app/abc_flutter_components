import 'package:flutter/material.dart';

class RaisedButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final VoidCallback onPressed;
  final RoundedRectangleBorder? shape;
  final Color? textColor;
  final ButtonTextTheme? textTheme;
  final double? elevation;

  const RaisedButton({
    super.key,
    required this.child,
    this.color,
    this.padding,
    required this.onPressed,
    this.shape,
    this.textColor,
    this.textTheme,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: shape,
      padding: padding,
      onPressed: onPressed,
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
      textColor: textColor,
      textTheme: textTheme,
      elevation: elevation ?? 4,
      child: child,
    );
  }
}
