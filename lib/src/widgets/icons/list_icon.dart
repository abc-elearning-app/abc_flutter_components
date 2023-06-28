import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../utils/index.dart';

class ListIcon extends StatelessWidget {
  final String? color;
  final double? width;
  final double? height;

  const ListIcon(
      {super.key, this.color = "#212121", this.height = 20, this.width = 20});

  String getIconContent(String color) {
    return '''
      <svg width="$width" height="$height" viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M16.6667 3.3335H3.33333C2.875 3.3335 2.5 3.7085 2.5 4.16683V5.8335C2.5 6.29183 2.875 6.66683 3.33333 6.66683H16.6667C17.125 6.66683 17.5 6.29183 17.5 5.8335V4.16683C17.5 3.7085 17.125 3.3335 16.6667 3.3335ZM3.33333 8.3335H16.6667C17.125 8.3335 17.5 8.7085 17.5 9.16683V10.0002C17.5 10.4585 17.125 10.8335 16.6667 10.8335H3.33333C2.875 10.8335 2.5 10.4585 2.5 10.0002V9.16683C2.5 8.7085 2.875 8.3335 3.33333 8.3335ZM3.33333 12.5002H16.6667C17.125 12.5002 17.5 12.8752 17.5 13.3335C17.5 13.7918 17.125 14.1668 16.6667 14.1668H3.33333C2.875 14.1668 2.5 13.7918 2.5 13.3335C2.5 12.8752 2.875 12.5002 3.33333 12.5002ZM2.91667 15.8335H17.0833C17.3167 15.8335 17.5 16.0168 17.5 16.2502C17.5 16.4835 17.3167 16.6668 17.0833 16.6668H2.91667C2.68333 16.6668 2.5 16.4835 2.5 16.2502C2.5 16.0168 2.68333 15.8335 2.91667 15.8335Z" fill="$color"/>
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
