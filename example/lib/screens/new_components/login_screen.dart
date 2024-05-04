import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class TestLoginScreen extends StatelessWidget {
  const TestLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tabDataList = <LoginDataItem>[
      LoginDataItem(
          image: Stack(
            alignment: Alignment.center,
            children: [
              Image.asset('assets/images/login_1_1.png'),
              Image.asset('assets/images/login_1_2.png')
            ],
          ),
          detail:
          "Log in now to receive personalized recommendations for practice and sync progress across devices."),
      LoginDataItem(
          image: Image.asset('assets/images/login_2.png'),
          detail:
          "Please enter the verification code we sent to your email address within 30 minutes. If you don't see it, check your spam folder.")
    ];

    return LoginPages(
      tabDataList: tabDataList,
      onRequestCodeClick: (email) => print(email),
      onSkip: () => print('onSkip'),
      onSubmit: (otp) => print(otp),
    );
  }
}
