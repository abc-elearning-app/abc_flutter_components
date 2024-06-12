import 'package:flutter/material.dart';

class EmailPage extends StatelessWidget {
  final String image;
  final String detail;
  final Color mainColor;
  final Color secondaryColor;
  final bool isDarkMode;
  final TextEditingController emailController;
  final void Function() onEnterEmail;

  const EmailPage(
      {super.key,
      required this.image,
      required this.detail,
      required this.emailController,
      required this.onEnterEmail,
      required this.mainColor,
      required this.secondaryColor,
      required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 2, child: Image.asset(image)),

        // Detail text
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(30),
            // Scroll view for small screen
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

        // Email text field
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 50),
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
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: isDarkMode ? mainColor : secondaryColor));

    // Add padding when keyboard appear
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: TextField(
        onChanged: (_) => onEnterEmail(),
        controller: emailController,
        cursorColor: const Color(0xFF307561),
        decoration: InputDecoration(
          filled: true,
          hintText: 'Please type your email address!',
          hintStyle: TextStyle(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.24)
                  : Colors.grey.shade300,
              fontSize: 18),
          fillColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
          focusedBorder: border,
          enabledBorder: border,
        ),
      ),
    );
  }
}
