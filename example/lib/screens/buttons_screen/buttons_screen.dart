import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ButtonsScreen extends StatelessWidget {
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            FlatButton(child: const Text("Flat Button"), onPressed: () {}),
            MainButton(title: "Main Button", onPressed: () {}),
            OutlineButton(
              onPressed: () {},
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(width: 1, color: Colors.blue)),
              child: const Text("Outlined Button"),
            ),
            RaisedButton(child: const Text("Raised Button"), onPressed: () {})
          ],
        ),
      ),
    );
  }
}
