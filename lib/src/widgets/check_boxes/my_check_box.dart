import 'package:flutter/material.dart';

class MyCheckBox extends StatelessWidget {
  final bool value;
  final bool unCheckIcon;
  final Color? activeColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? fillColor;
  final double borderWidth;
  final void Function(bool value)? onChanged;

  const MyCheckBox({
    super.key,
    this.unCheckIcon = true,
    this.value = false,
    this.onChanged,
    this.activeColor,
    this.borderColor,
    this.iconColor,
    this.fillColor,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged?.call(!value);
      },
      child: _makeBox(value, context),
    );
  }

  Widget _makeBox(bool active, BuildContext context) {
    if (unCheckIcon == false && !active) {
      return const SizedBox();
    }
    return Container(
      decoration: active
          ? BoxDecoration(
              color: activeColor ?? Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: activeColor ?? Theme.of(context).colorScheme.secondary, width: borderWidth))
          : BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderColor ?? Theme.of(context).colorScheme.secondary, width: borderWidth)),
      child: active ? Icon(Icons.done, color: iconColor ?? Theme.of(context).colorScheme.surface, size: 16) : const SizedBox(width: 16, height: 16),
    );
  }
}
