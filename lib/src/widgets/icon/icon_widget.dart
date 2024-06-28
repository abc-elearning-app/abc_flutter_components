import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconWidget extends StatelessWidget {
  final String icon;
  final double? height;
  final double? width;
  final Color? color;

  const IconWidget({
    super.key,
    required this.icon,
    this.height,
    this.width,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (icon.endsWith('png')) {
      return Image.asset(icon, width: width, height: height, color: color);
    } else if (icon.endsWith('svg')) {
      return SvgPicture.asset(icon,
          width: width,
          height: height,
          colorFilter:
              color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null);
    } else if (icon.contains('http')) {
      return Image.network(icon, width: width, height: height, color: color);
    } else {
      return Image.asset(
        'assets/images/bookmarked.svg',
        width: width,
        height: height,
        color: color,
      );
    }
  }
}
