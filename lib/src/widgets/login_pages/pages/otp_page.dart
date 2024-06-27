import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpPage extends StatelessWidget {
  final String image;
  final String imageDark;
  final String detail;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;
  final TextEditingController otpController;
  final void Function() onReenterEmail;
  final void Function() onEnterOtp;

  const OtpPage(
      {super.key,
      required this.image,
      required this.imageDark,
      required this.detail,
      required this.otpController,
      required this.onReenterEmail,
      required this.onEnterOtp,
      required this.mainColor,
      required this.secondaryColor,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final customPinTheme = PinTheme(
        textStyle: const TextStyle(fontSize: 12),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: isDarkMode ? Colors.grey.shade900 : Colors.white,
            border: Border.all(
                width: 0.5, color: isDarkMode ? mainColor : secondaryColor)));

    return Column(
      children: [
        const SizedBox(height: 30),
        Expanded(flex: 2, child: Padding(
          padding: const EdgeInsets.all(20),
          child: Image.asset(isDarkMode ? imageDark : image),
        )),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(30),
            // Scroll view for small screen to avoid overflow
            child: SingleChildScrollView(
              child: Text(
                detail,
                style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black),
                textAlign: TextAlign.center,
              ),
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
              style: TextStyle(
                  fontSize: 16, color: isDarkMode ? mainColor : secondaryColor),
            ),
          ),
        ),
      ],
    );
  }
}
