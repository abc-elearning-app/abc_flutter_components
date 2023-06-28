import 'package:flutter/material.dart';

import '../../utils/color_utils.dart';

class Login {
  Container signInWithOtherMethod(
      BuildContext context, String method, String textColor, String backgroundColor, String logo, Function onTap) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      margin: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
      child: ElevatedButton(
        onPressed: () {
          onTap();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.pressed)) {
                return Colors.black26;
              }
              return HexColor(backgroundColor);
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(logo, width: 20,),
            const SizedBox(width: 20,),
            Text(
              method,
              style: TextStyle(
                color: HexColor(textColor),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
