import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

Future<dynamic> showUnlockedPartDialog({
  required BuildContext context,
  required VoidCallback onNext,
}) async {
  return await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      content: InkWell(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
        onTap: () => Navigator.pop(context),
        child: Container(
          color: Colors.transparent,
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: Image.asset(
            "assets/gifs/unlocked_part.gif",
            fit: BoxFit.contain,
            package: appPackage,
          ),
        ),
      ),
    ),
  ).whenComplete(onNext);
}
