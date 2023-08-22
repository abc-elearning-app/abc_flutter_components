import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class MenusScreen extends StatelessWidget {
  const MenusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Menu Button Get Pro"),
            const SizedBox(
              height: 10,
            ),
            MenuButtonGetPro(onPress: () {}),
            const SizedBox(
              height: 20,
            ),
            const Text("Menu Item"),
            const SizedBox(
              height: 10,
            ),
            makeGamePopupMenuItem(
              context: context,
              bookmark: true,
              showReportMistake: () {},
              bookmarkQuestion: () {},
              fontSize: ValueNotifier(14.0),
              onChangeFontSizeFinished: (_) {},
            )
          ],
        ),
      ),
    );
  }
}
