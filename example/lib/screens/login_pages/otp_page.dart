import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  final Widget image;
  final String detail;
  final Color textColor;
  final Color mainColor;
  final TextEditingController otpController;
  final void Function() onReenterEmail;
  final void Function() onEnterOtp;

  const OtpPage(
      {super.key,
      required this.image,
      required this.detail,
      required this.otpController,
      required this.onReenterEmail,
      required this.onEnterOtp,
      required this.textColor,
      required this.mainColor});

  @override
  Widget build(BuildContext context) {
    final customPinTheme = PinTheme(
        textStyle: const TextStyle(fontSize: 12),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.white,
            border: Border.all(width: 0.5, color: mainColor)));

    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(child: image),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text(
              detail,
              style: TextStyle(fontSize: 18, color: textColor),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Transform.scale(
          scale: 2,
          child: Pinput(
            controller: otpController,
            defaultPinTheme: customPinTheme,
            focusedPinTheme: customPinTheme,
            onChanged: (_) => onEnterOtp(),
            onCompleted: (pin) {},
          ),
        ),
        GestureDetector(
          onTap: () => onReenterEmail(),
          child: Padding(
            padding: const EdgeInsets.only(top: 30, bottom: 50),
            child: Text(
              'Enter Another Email',
              style: TextStyle(fontSize: 16, color: mainColor),
            ),
          ),
        ),
      ],
    );
  }
}
