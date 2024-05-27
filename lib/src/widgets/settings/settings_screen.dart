import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/floating_pieces.dart';
import 'package:flutter_abc_jsc_components/src/widgets/settings/widgets/gif_icon.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  final double buttonHeight = 70.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4EE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SvgPicture.asset('assets/images/avatar.svg'))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 2,
                          spreadRadius: 2)
                    ]),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(alignment: Alignment.center, children: [
                    Container(
                        width: double.infinity,
                        height: buttonHeight,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xFFFF9840),
                                  Color(0xFFFF544E)
                                ]),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade300,
                                  spreadRadius: 2,
                                  blurRadius: 2)
                            ])),
                    FloatingAnimation(buttonHeight: buttonHeight),
                    SizedBox(
                      width: double.infinity,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            shadowColor: Colors.transparent),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Transform.translate(
                                offset: const Offset(-15, 0),
                                child: const GifIcon()),
                            RichText(
                              text: const TextSpan(
                                  style: TextStyle(
                                      fontFamily: 'Poppins', fontSize: 20),
                                  children: [
                                    TextSpan(
                                        text: 'Upgrade',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: ' to the Premium'),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
