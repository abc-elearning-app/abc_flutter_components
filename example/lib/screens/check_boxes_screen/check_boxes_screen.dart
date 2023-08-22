import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class CheckBoxesScreen extends StatefulWidget {
  const CheckBoxesScreen({super.key});

  @override
  State<CheckBoxesScreen> createState() => _CheckBoxesScreenState();
}

class _CheckBoxesScreenState extends State<CheckBoxesScreen> {
  var _checked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Normal Checkbox"),
            const SizedBox(
              height: 10,
            ),
            Checkbox(
                value: _checked,
                onChanged: (val) => setState(() => _checked = val!)),
            const SizedBox(
              height: 30,
            ),
            const Text("My Checkbox"),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 30,
              width: 30,
              child: MyCheckBox(
                value: _checked,
                onChanged: (val) => setState(() => _checked = val),
              ),
            )
          ],
        ),
      ),
    );
  }
}
