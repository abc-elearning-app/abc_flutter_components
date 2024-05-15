import 'package:flutter/material.dart';

import '../../../../flutter_abc_jsc_components.dart';

Widget reviewButton(BuildContext context) => Container(
    width: double.infinity,
    margin: const EdgeInsets.symmetric(horizontal: 15),
    child: MainButton(
      onPressed: () {},
      title: 'Review My Answers',
      textStyle: const TextStyle(fontSize: 18),
      textColor: const Color(0xFF579E89),
      borderSize: const BorderSide(width: 1, color: Color(0xFF579E89)),
      borderRadius: 15,
      backgroundColor: Colors.white,
    ));

Widget tryAgainButton() => Container(
      padding: const EdgeInsets.only(left: 15, right: 5, bottom: 25, top: 20),
      child: MainButton(
        title: 'Try Again',
        borderRadius: 15,
        backgroundColor: Colors.white,
        textColor: const Color(0xFFE3A651),
        borderSize: const BorderSide(width: 1, color: Color(0xFFE3A651)),
        textStyle: const TextStyle(fontSize: 18),
        onPressed: () {},
      ),
    );

Widget continueButton() => Container(
      padding: const EdgeInsets.only(left: 5, right: 15, bottom: 25, top: 20),
      child: MainButton(
        title: 'Continue',
        borderRadius: 15,
        backgroundColor: const Color(0xFFE3A651),
        textStyle: const TextStyle(fontSize: 18),
        onPressed: () {},
      ),
    );
