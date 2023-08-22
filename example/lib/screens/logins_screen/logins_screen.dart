import 'package:example/screens/emails_screen/emails_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class LoginsScreen extends StatelessWidget {
  const LoginsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Choose your option"),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context).colorScheme.onSurface)),
              child: ChooseLoginOption(
                  isAppleAvailable: isAppleAvailable,
                  onSignInWithGoogle: () {},
                  onSignInWithApple: () {},
                  onSignInWithEmail: () {},
                  privacyPolicyWidget: const PrivacyPolicy()),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Sign in with other method widget"),
            const SizedBox(
              height: 10,
            ),
            Login().signInWithOtherMethod(
                context,
                "Google",
                getHexCssColor(Theme.of(context).colorScheme.onPrimary),
                getHexCssColor(Theme.of(context).colorScheme.primary),
                "assets/rating_icon_1.png",
                () {}),
            const SizedBox(
              height: 20,
            ),
            const Text("Sign in button"),
            const SizedBox(
              height: 10,
            ),
            SignInButton(
              signInIcon: SignInIcon.apple,
              title: "Sign in with Apple",
              onPress: () {},
              backgroundColor: Theme.of(context).colorScheme.secondary,
              textColor: Theme.of(context).colorScheme.onSecondary,
            )
          ],
        ),
      ),
    );
  }

  Future<bool> isAppleAvailable() async {
    return true;
  }
}
