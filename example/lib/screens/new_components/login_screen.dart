import 'package:example/constants/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLoginScreen extends StatelessWidget {
  const TestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabDataList = <LoginItem>[
      LoginItem(
          image: 'assets/images/login_mail.png',
          detail:
              "Log in now to receive personalized recommendations for practice and sync progress across devices.",
          imageDark: ''),
      LoginItem(
          image: 'assets/images/login_otp.png',
          detail:
              "Please enter the verification code we sent to your email address within 30 minutes. If you don't see it, check your spam folder.",
          imageDark: '')
    ];

    return LoginPages(
      tabDataList: tabDataList,
      onRequestCodeClick: (email) => print(email),
      onSkip: () => print('onSkip'),
      onSubmit: (otp) {
        print(otp);
        Navigator.of(context).pop();
      },
      isDarkMode: AppTheme.isDarkMode,
    );
  }
}
