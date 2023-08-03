import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../flutter_abc_jsc_components.dart';

class ToastWarningIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const ToastWarningIcon(
      {super.key, this.color, this.height, this.width = 24});

  String getIconContent(String color) {
    return '''
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M10 0C4.48 0 0 4.48 0 10C0 15.52 4.48 20 10 20C15.52 20 20 15.52 20 10C20 4.48 15.52 0 10 0ZM10 11C9.45 11 9 10.55 9 10V6C9 5.45 9.45 5 10 5C10.55 5 11 5.45 11 6V10C11 10.55 10.55 11 10 11ZM9 13V15H11V13H9Z" fill="$color"/>
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
