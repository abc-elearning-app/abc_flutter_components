import 'package:flutter/material.dart';

class EmailPage extends StatelessWidget {
  final Widget image;
  final String detail;
  final TextEditingController emailController;
  final void Function() onEnterEmail;

  const EmailPage(
      {super.key,
      required this.image,
      required this.detail,
      required this.emailController,
      required this.onEnterEmail});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: image),

        // Detail text
        Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            detail,
            style: TextStyle(fontSize: 18, color: Colors.grey.shade700),
            textAlign: TextAlign.center,
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

              // Add padding when keyboard appear
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 20),
                child: TextField(

                  onChanged: (_) => onEnterEmail(),
                  controller: emailController,
                  cursorColor: const Color(0xFF307561),
                  decoration: InputDecoration(
                      filled: true,
                      hintText: 'Type your email',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade300, fontSize: 18),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Color(0xFF307561))),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide:
                              const BorderSide(color: Color(0xFF307561)))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
