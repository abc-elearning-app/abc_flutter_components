import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum SignInIcon { google, apple, email }

class SignInButton extends StatelessWidget {
  final String signInIcon;
  final String title;
  final VoidCallback onPress;
  final Color backgroundColor;
  final Color? textColor;

  const SignInButton({
    super.key,
    required this.signInIcon,
    required this.title,
    required this.onPress,
    required this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(40)),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: SizedBox(
          width: Platform.isIOS ? 190 : 200,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                signInIcon,
                width: 24,
              ),
              const SizedBox(width: 12),
              Text(title,
                  style:
                  TextStyle(color: textColor, fontWeight: FontWeight.w500))
            ],
          ),
        ),
      ),
    );
  }
}
