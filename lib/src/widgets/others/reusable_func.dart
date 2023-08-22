import 'package:flutter/material.dart';

void showMySnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
    text,
    style: const TextStyle(color: Colors.black),
  )));
}

void showMyDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        child: SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              CircularProgressIndicator(),
              SizedBox(
                width: 20,
              ),
              Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}
