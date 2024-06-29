import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

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
    if (icon.endsWith('png') || icon.endsWith('jpg') || icon.endsWith('jpeg')) {
      return Image.asset(icon, width: width, height: height, color: color);
    } else if (icon.endsWith('svg')) {
      return SvgPicture.asset(icon, width: width, height: height, colorFilter: color == null ? null : ColorFilter.mode(color!, BlendMode.srcIn),);
    } else if (icon.endsWith('json')) {
      return Lottie.asset(icon, width: width, height: height);
    } else if (icon.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: icon,
        width: width,
        height: height,
        color: color,
        errorWidget: (context, url, error) => _makeIconDefault(),
      );
    } else {
      return _makeIconDefault();
    }
  }

  Widget _makeIconDefault() {
    return Icon(
      Icons.folder,
      size: width,
      color: color,
    );
  }
}
