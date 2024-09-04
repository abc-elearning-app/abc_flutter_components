import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class EmailPage extends StatefulWidget {
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
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              //Image
              SizedBox(
                width: double.infinity,
                child: IconWidget(icon: widget.image, height: 200),
              ),

              // Detail text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Text(
                  widget.detail,
                  style: TextStyle(fontSize: 16, color: widget.isDarkMode ? Colors.white.withOpacity(0.6) : Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),

              // Google and Apple login
              _buildSocialMediaButton(iconData: FontAwesomeIcons.google, title: 'Sign in with Google', onPressed: widget.onGoogleSignIn),
              if (Platform.isIOS) _buildSocialMediaButton(iconData: FontAwesomeIcons.apple, title: 'Sign in with Apple', onPressed: widget.onAppleSignIn),

              // Email text field
              Container(
                color: Colors.transparent,
                width: double.infinity,
                child: const Row(
                  children: [
                    Expanded(child: Divider(indent: 20)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('Or', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                    ),
                    Expanded(child: Divider(endIndent: 20)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Email',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildEmailTextField(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailTextField() {
    final border = OutlineInputBorder(
        borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: widget.isDarkMode ? widget.mainColor : widget.secondaryColor));

    // Add padding when keyboard appear
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 20),
      child: TextField(
        onChanged: (_) => widget.onEnterEmail(),
        focusNode: focusNode,
        controller: widget.emailController,
        cursorColor: widget.isDarkMode ? widget.mainColor : widget.secondaryColor,
        decoration: InputDecoration(
          filled: true,
          hintText: 'Please type your email address!',
          hintStyle: TextStyle(color: widget.isDarkMode ? Colors.white.withOpacity(0.24) : Colors.grey.shade300, fontSize: 16),
          fillColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
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
        onPressed: () {
          FocusScope.of(context).unfocus();
          onPressed();
        },
        style: ElevatedButton.styleFrom(
            foregroundColor: widget.secondaryColor,
            backgroundColor: widget.isDarkMode ? Colors.grey.shade900 : Colors.white,
            side: BorderSide(width: 0.8, color: widget.isDarkMode ? widget.mainColor : widget.secondaryColor),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)),
        child: Row(
          children: [
            FaIcon(iconData, color: widget.isDarkMode ? widget.mainColor : widget.secondaryColor),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(color: widget.isDarkMode ? widget.mainColor : widget.secondaryColor, fontSize: 16))),
          ],
        ),
      ),
    );
  }
}
