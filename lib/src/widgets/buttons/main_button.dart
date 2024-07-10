import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? loadingColor;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final BorderSide? borderSize;
  final bool loading;
  final int delayPressedMilliseconds;
  final EdgeInsets? padding;
  final bool disabled;
  final TextStyle? textStyle;
  final double borderRadius;
  final Widget? icon;

  const MainButton(
      {super.key,
      this.delayPressedMilliseconds = 100,
      this.loading = false,
      required this.title,
      this.borderSize,
      required this.onPressed,
      this.padding,
      this.backgroundColor,
      this.textColor,
      this.loadingColor,
      this.disabled = false,
      this.disabledTextColor,
      this.disabledColor,
      this.textStyle,
      this.icon,
      this.borderRadius = 12});

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? Theme.of(context).colorScheme.primary;
    bool temp = false;
    return MaterialButton(
      disabledColor: disabledColor ?? Colors.grey,
      disabledTextColor: disabledTextColor ?? Colors.white,
      elevation: 0,
      color: bgColor,
      hoverColor: Colors.white38,
      highlightColor: Colors.white38,
      shape: borderSize != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              side: borderSize!)
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
      padding: padding ?? const EdgeInsets.all(12),
      onPressed: disabled
          ? null
          : () {
              if (temp || loading == true) {
                return;
              }
              temp = true;
              Future.delayed(Duration(milliseconds: delayPressedMilliseconds),
                  () {
                temp = false;
              });
              onPressed.call();
            },
      child: icon != null ? Stack(
        children: [
          icon!,
          _text()
        ],
      ) : _text(),
    );
  }

  Widget _text() {
    return loading
          ? _makeLoading(loadingColor ?? Colors.grey)
          : Text(title,
              style: (textStyle ?? const TextStyle())
                  .copyWith(color: textColor ?? Colors.white));
  }

  Widget _makeLoading(Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        )
      ],
    );
  }
}
