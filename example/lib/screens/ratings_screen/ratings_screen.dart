import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text("Rating Bottom Sheet"),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async => await showRatingFeedbackBottomSheet(
                  context,
                  onSubmit: () {},
                  ratingDataRecordDecline: () {},
                  goToAtStore: () {},
                  rattingDataRecordRated: () {}),
              child: const Text("Show Rating Bottom Sheet"),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text("Rating View"),
            const SizedBox(
              height: 10,
            ),
            RatingView(
              onRating: () {},
              hasBackground: true,
              onSubmit: () {},
              ratingDataRecordDecline: () {},
              goToAtStore: () {},
              rattingDataRecordRated: () {},
            )
          ],
        ),
      ),
    );
  }
}
