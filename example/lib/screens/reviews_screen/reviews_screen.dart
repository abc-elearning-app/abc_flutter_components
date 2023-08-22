import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            ReviewItem(
              iconName: "google",
              title: "Title",
              subtitle: Text("Subtitle"),
            )
          ],
        ),
      ),
    );
  }
}
