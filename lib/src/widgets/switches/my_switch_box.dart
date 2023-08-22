import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/utils/color_utils.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/switch_icon.dart';

class MySwitchBox extends StatelessWidget {
  final bool value;
  final void Function(bool value) onChanged;
  final double size;

  const MySwitchBox(
      {super.key, this.size = 24, this.value = false, required this.onChanged});

  final double defaultSize = 24;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged.call(!value);
      },
      child: SwitchIcon(
        on: value,
        color: value
            ? getHexCssColor(const Color(0xFF00C99E))
            : getHexCssColor(const Color(0xFF8E8E8E)),
        width: size,
        height: size * 2 / 3,
        isDarkMode: Theme.of(context).colorScheme.brightness == Brightness.dark,
      ),
    );
  }
}
