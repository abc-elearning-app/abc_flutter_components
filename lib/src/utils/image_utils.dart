import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ResponsiveIcon extends StatelessWidget {
  final String content;
  final String color;
  final double width;
  final double height;

  const ResponsiveIcon(
      {super.key,
      required this.content,
      this.color = 'black',
      this.height = 25,
      this.width = 25});

  getIconContent(String color) => content
      .toString()
      .replaceAll('stroke="white"', 'stroke="$color"')
      .replaceAll('fill="white"', 'fill="$color"');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        width: width,
        child: SvgPicture.string(getIconContent(color)));
  }
}
