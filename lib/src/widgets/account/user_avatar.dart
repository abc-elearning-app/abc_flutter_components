import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';

class UserAvatar extends StatelessWidget {
  final bool isPro;
  final String avatar;
  final String username;
  final String crownIcon;

  const UserAvatar(
      {super.key,
      required this.isPro,
      required this.avatar,
      required this.username,
      required this.crownIcon});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      CircleAvatar(
        radius: 20,
        backgroundColor: isPro ? const Color(0xFFF0BD3A) : Colors.transparent,
        child: CircleAvatar(
            backgroundImage:
                avatar.isEmpty ? null : CachedNetworkImageProvider(avatar),
            radius: 35 / 2,
            child: avatar.isEmpty ? Text(username[0].toUpperCase()) : null),
      ),

      // Crown for pro account
      if (isPro)
        Transform.translate(
            offset: const Offset(0, -10),
            child: IconWidget(
              icon: crownIcon,
              height: 12,
            )),
    ]);
  }
}
