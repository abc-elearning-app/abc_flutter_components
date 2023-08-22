import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ProgressItemsScreen extends StatelessWidget {
  const ProgressItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Animated Topic Progress Widget"),
            const SizedBox(
              height: 10,
            ),
            AnimatedTopicProgressWidget(
              progress: 39,
              progressItems: [
                AppBarProgressItem(title: "Not seen", value: "20"),
                AppBarProgressItem(
                    title: "Familiar", value: "30", icon: Icons.done),
                AppBarProgressItem(
                    title: "Mastered", value: "50", icon: Icons.done_all),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Topic Progress Widget"),
            const SizedBox(
              height: 10,
            ),
            TopicProgressWidget(
              progress: 39,
              progressItems: [
                AnimatedAppBarProgressItem(title: "Not seen", value: "20"),
                AnimatedAppBarProgressItem(
                    title: "Familiar", value: "30", icon: Icons.done),
                AnimatedAppBarProgressItem(
                    title: "Mastered", value: "50", icon: Icons.done_all),
              ],
              testBackgroundPath: 'assets/test_background_items.jpg',
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Full Circle Progress"),
            const SizedBox(
              height: 10,
            ),
            const FullCircleProgressIndicator(
              value: 0.39,
              correctColor: Colors.green,
              incorrectColor: Colors.red,
              radius: 100,
              lineWidth: 15,
              centerWidget: Text("Center Widget"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Half Circle Progress"),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: HaftCircleProgressIndicator(
                value: 0.39,
                correctColor: Colors.green,
                incorrectColor: Colors.red,
                radius: 100,
                lineWidth: 15,
                textColor: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Linear Progress"),
            const SizedBox(
              height: 10,
            ),
            LinearProgress(
                value: 0.2,
                minHeight: 20,
                textColor: Theme.of(context).colorScheme.onSurface),
            const SizedBox(
              height: 10,
            ),
            LinearProgress2(
              total: 90,
              value1: 30,
              value2: 20,
              minHeight: 20,
              valueColor1: Theme.of(context).colorScheme.secondary,
              valueColor2: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Part Progress"),
            const SizedBox(
              height: 10,
            ),
            const PartProgressIndicator(
              total: 50,
              correct: 40,
              name: "Test",
              requiredPass: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Topic Progress"),
            const SizedBox(
              height: 10,
            ),
            TopicProgressIndicator(
              color: Theme.of(context).colorScheme.tertiary,
              progress: 13.4,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Update Progress Widget"),
            const SizedBox(
              height: 10,
            ),
            UpdateProgressWidget(
              updateUserDataValueNotifier: ValueNotifier(30),
              textColor: Theme.of(context).colorScheme.onSurface,
            )
          ],
        ),
      ),
    );
  }
}
