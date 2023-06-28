import 'package:flutter/material.dart';

void showUnlockedPartDialog(
    {required String gifStringPath,
    required BuildContext context,
    required VoidCallback onNext}) {
  showDialog(
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
          child: Image.asset(gifStringPath, fit: BoxFit.contain),
        ),
      ),
    ),
  ).whenComplete(onNext);
}
