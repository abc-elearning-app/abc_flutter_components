import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class UserInformation extends StatelessWidget {
  final bool isPro;
  final String avatar;
  final String email;
  final String username;

  final String crownIcon;

  const UserInformation({
    super.key,
    required this.isPro,
    required this.avatar,
    required this.email,
    required this.username,
    required this.crownIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserAvatar(
            isPro: isPro,
            avatar: avatar,
            username: username,
            crownIcon: crownIcon),

        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            email,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
