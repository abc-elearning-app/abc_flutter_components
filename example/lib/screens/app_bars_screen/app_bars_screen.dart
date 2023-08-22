import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class AppBarsScreen extends StatelessWidget {
  const AppBarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("My app bar 1"),
            const SizedBox(
              height: 10,
            ),
            MyAppBar1(
              title: Text(
                "My App",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text("My app bar 2"),
            const SizedBox(
              height: 10,
            ),
            const MyAppBar2(
              titlePanel: Text("My App"),
            )
          ],
        ),
      ),
    );
  }
}
