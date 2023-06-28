import 'dart:io';

import 'package:flutter/material.dart';

import '../index.dart';

class ChooseLoginOption extends StatefulWidget {
  final bool isDarkMode;
  final String iconAssetGoogle;
  final String iconAssetApple;
  final String iconAssetEmail;
  final Widget privacyPolicyWidget;
  final Future<bool> Function() isAppleAvailable;
  final VoidCallback onSignInWithGoogle;
  final VoidCallback onSignInWithApple;
  final VoidCallback onSignInWithEmail;

  const ChooseLoginOption({
    super.key,
    required this.isDarkMode,
    required this.iconAssetGoogle,
    required this.iconAssetApple,
    required this.iconAssetEmail,
    required this.isAppleAvailable,
    required this.onSignInWithGoogle,
    required this.onSignInWithApple,
    required this.onSignInWithEmail,
    required this.privacyPolicyWidget,
  });

  @override
  State<ChooseLoginOption> createState() => _ChooseLoginOptionState();
}

class _ChooseLoginOptionState extends State<ChooseLoginOption> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 28),
        Text(
          "Choose your option",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 16),
        Text("You can login easily with many options!",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w400)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SignInButton(
                signInIcon: widget.iconAssetGoogle,
                title: "Sign up with Google",
                onPress: widget.onSignInWithGoogle,
                backgroundColor: Colors.white,
              ),
              if (Platform.isIOS)
                FutureBuilder<bool>(
                    future: widget.isAppleAvailable(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data as bool) {
                        return SignInButton(
                          signInIcon: widget.iconAssetApple,
                          title: "Sign in with Apple",
                          onPress: widget.onSignInWithApple,
                          backgroundColor: const Color(0xFF333333),
                          textColor: Colors.white,
                        );
                      }
                      return const SizedBox();
                    }),
              SignInButton(
                signInIcon: widget.iconAssetEmail,
                title: "Sign in with Email",
                onPress: widget.onSignInWithEmail,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
              )
            ],
          ),
        ),
        widget.privacyPolicyWidget,
      ],
    );
  }
}
