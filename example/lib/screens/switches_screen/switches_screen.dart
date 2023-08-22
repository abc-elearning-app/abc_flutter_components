import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class SwitchesScreen extends StatefulWidget {
  const SwitchesScreen({super.key});

  @override
  State<SwitchesScreen> createState() => _SwitchesScreenState();
}

class _SwitchesScreenState extends State<SwitchesScreen> {

  final check = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ValueListenableBuilder(
              valueListenable: check,
              builder: (_, value, __) =>
                  MySwitchBox(
                    value: value,
                    onChanged: (bool value) {
                      check.value = value;
                    },
                    size: 50,
                  ),
            )
          ],
        ),
      ),
    );
  }
}
