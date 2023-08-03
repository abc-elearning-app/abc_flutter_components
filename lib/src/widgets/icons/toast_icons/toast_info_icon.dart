import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../flutter_abc_jsc_components.dart';

class ToastInfoIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const ToastInfoIcon(
      {super.key, this.color, this.height, this.width = 24});

  String getIconContent(String color) {
    return '''
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M12 16V12M12 8H12.01M22 12C22 17.5228 17.5228 22 12 22C6.47715 22 2 17.5228 2 12C2 6.47715 6.47715 2 12 2C17.5228 2 22 6.47715 22 12Z" stroke="$color" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
        getIconContent(
            color ?? getHexCssColor(Theme.of(context).colorScheme.primary)),
        width: width,
        height: height);
  }
}
