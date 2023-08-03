import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../flutter_abc_jsc_components.dart';

class ToastCheckedIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const ToastCheckedIcon(
      {super.key, this.color, this.height, this.width = 24});

  String getIconContent(String color) {
    return '''
      <svg width="20" height="20" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path fill-rule="evenodd" clip-rule="evenodd" d="M0 10C0 4.48 4.48 0 10 0C15.52 0 20 4.48 20 10C20 15.52 15.52 20 10 20C4.48 20 0 15.52 0 10ZM5.5855 10.5771L8.47717 13.4688L15.0438 6.07711C15.1995 5.92107 15.4109 5.83337 15.6313 5.83337C15.8518 5.83337 16.0631 5.92107 16.2188 6.07711C16.5438 6.40211 16.5438 6.92711 16.2188 7.25211L9.06883 15.2354C8.74383 15.5604 8.21883 15.5604 7.89383 15.2354L4.4105 11.7521C4.0855 11.4271 4.0855 10.9021 4.4105 10.5771C4.56619 10.4211 4.77757 10.3334 4.998 10.3334C5.21843 10.3334 5.42981 10.4211 5.5855 10.5771Z" fill="$color"/>
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
