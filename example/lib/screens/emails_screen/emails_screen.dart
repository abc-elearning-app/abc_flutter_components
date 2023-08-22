import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailsScreen extends StatelessWidget {
  const EmailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return EnterEmailSheet(
      privacyPolicyWidget: const PrivacyPolicy(),
      clickLogin: () {},
      buttonSubmitClick: () {},
      buttonVerifyCodeClick: () {},
      onSendEmail: () {},
      onVerifyCode: () {},
    );
  }
}

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'By signing in your accept our',
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : const Color(0xFF212121)),
            ),
          ),
          GestureDetector(
            onTap: _goToPrivacy,
            child: Text('Privacy Policy',
                style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : const Color(0xFF212121),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }

  void _goToPrivacy() async {
    const url = 'https://abcelearning.github.io/mobileapps/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
