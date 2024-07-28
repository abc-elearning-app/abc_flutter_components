import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class EmailPage extends StatelessWidget {
  final String image;
  final String detail;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;
  final TextEditingController emailController;
  final void Function() onEnterEmail;
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  const EmailPage({
    super.key,
    required this.image,
    required this.detail,
    required this.emailController,
    required this.onEnterEmail,
    required this.mainColor,
    required this.secondaryColor,
    required this.isDarkMode,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 4, child: IconWidget(icon: image)),
        // Detail text
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(30),
            // Scroll view for small screen
            child: SingleChildScrollView(
              child: Text(
                detail,
                style: TextStyle(fontSize: 16, color: isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        _buildSocialMediaButton(iconData: FontAwesomeIcons.google, title: 'Sign in with Google', onPressed: onGoogleSignIn),
        if (Platform.isIOS) _buildSocialMediaButton(iconData: FontAwesomeIcons.apple, title: 'Sign in with Apple', onPressed: onAppleSignIn),
        // Email text field
        const Row(
          children: [
            Expanded(child: Divider(indent: 20)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Or', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Expanded(child: Divider(endIndent: 20)),
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              _buildEmailTextField(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailTextField() {
    final border = OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: isDarkMode ? mainColor : secondaryColor));

    // Add padding when keyboard appear
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: TextField(
        onChanged: (_) => onEnterEmail(),
        controller: emailController,
        cursorColor: isDarkMode ? mainColor : secondaryColor,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Please type your email address!',
          hintStyle: TextStyle(color: isDarkMode ? Colors.white.withOpacity(0.24) : Colors.grey.shade300, fontSize: 16),
          fillColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
    );
  }

  Widget _buildSocialMediaButton({required IconData iconData, required String title, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          side: BorderSide(width: 0.8, color: isDarkMode ? mainColor : secondaryColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
        ),
        child: Row(
          children: [
            FaIcon(iconData, color: isDarkMode ? mainColor : secondaryColor),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(color: isDarkMode ? mainColor : secondaryColor, fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
