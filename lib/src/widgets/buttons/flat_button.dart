import 'package:flutter/material.dart';

class FlatButton extends StatelessWidget {
  final Widget child;
  final Color? color;
  final EdgeInsets? padding;
  final VoidCallback onPressed;
  final RoundedRectangleBorder? shape;
  final Color? textColor;
  final double? elevation;
  final ButtonTextTheme? textTheme;

  const FlatButton({
    Key? key,
    this.elevation,
    required this.child,
    this.color,
    this.padding,
    required this.onPressed,
    this.shape,
    this.textColor,
    this.textTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: elevation,
      shape: shape,
      padding: padding,
      onPressed: onPressed,
      color: color,
      textColor: textColor,
      textTheme: textTheme,
      child: child,
    );
  }
}
