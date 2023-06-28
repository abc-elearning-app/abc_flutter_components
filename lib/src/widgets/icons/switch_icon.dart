import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../utils/index.dart';

class SwitchIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool? on;
  final bool isDarkMode;

  const SwitchIcon({
    super.key,
    this.color,
    this.fit,
    this.height,
    this.width = 24,
    this.on = true,
    required this.isDarkMode,
  });

  String getIconOnContent(String color) {
    if (isDarkMode) {
      return '<svg width="48" height="32" viewBox="0 0 48 32" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="4" width="44" height="24" rx="12" fill="white"/><circle cx="32" cy="16" r="13" fill="#A7A7A7" stroke="white" stroke-width="2"/></svg>';
    }
    return '<svg width="48" height="32" viewBox="0 0 48 32" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="4" width="44" height="24" rx="12" fill="$color"/><circle cx="32" cy="16" r="13" fill="white" fill-opacity="0.27" stroke="$color" stroke-width="2"/></svg>';
  }

  String getIconOffContent(String color) {
    if (isDarkMode) {
      return '<svg width="48" height="32" viewBox="0 0 48 32" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="2" y="4" width="44" height="24" rx="12" fill="#868687"/><circle cx="16" cy="16" r="13" fill="white" fill-opacity="0.27" stroke="#868687" stroke-width="2"/></svg>';
    }
    return '<svg width="44" height="28" viewBox="0 0 44 28" fill="none" xmlns="http://www.w3.org/2000/svg"><rect y="2" width="44" height="24" rx="12" fill="$color"/><circle cx="14" cy="14" r="13" fill="white" stroke="$color" stroke-width="2"/></svg>';
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: on == true ? 1 : 0.9,
        child: SvgPicture.string(
            on == true
                ? getIconOnContent(color ??
                    getHexCssColor(Theme.of(context).colorScheme.primary))
                : getIconOffContent(color ?? "#868687"),
            width: width,
            height: height,
            fit: fit ?? BoxFit.contain));
  }
}
