import 'package:flutter/material.dart';

import '../../constants/index.dart';
import '../index.dart';

class RatingView extends StatefulWidget {
  final VoidCallback onRating;
  final bool hasBackground;
  final VoidCallback onSubmit;
  final VoidCallback ratingDataRecordDecline;
  final VoidCallback goToAtStore;
  final VoidCallback rattingDataRecordRated;

  const RatingView(
      {super.key,
      required this.onRating,
      required this.hasBackground,
      required this.onSubmit,
      required this.ratingDataRecordDecline,
      required this.goToAtStore,
      required this.rattingDataRecordRated});

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  bool _rating = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _rating == true
        ? RatingViewContent(
            onFeedback: () {
              setState(() {
                _rating = false;
              });
            },
            onRating: widget.onRating,
            hasBackground: widget.hasBackground,
          )
        : getRatingBottomSheet(
            context: context,
            onSubmit: widget.onSubmit,
            ratingDataRecordDecline: widget.ratingDataRecordDecline,
            goToAtStore: widget.goToAtStore,
            rattingDataRecordRated: widget.rattingDataRecordRated,
          );
  }
}

class RatingViewContent extends StatelessWidget {
  final VoidCallback onFeedback;
  final VoidCallback onRating;
  final bool hasBackground;

  const RatingViewContent({
    super.key,
    required this.onFeedback,
    required this.onRating,
    required this.hasBackground,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
        fontSize: 24,
        fontFamily: "Nutino",
        color: Theme.of(context).colorScheme.onSurface,
        fontWeight: FontWeight.w500);
    TextAlign textAlign = TextAlign.center;
    return Container(
      constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height - kToolbarHeight),
      padding: const EdgeInsets.only(left: 30, bottom: 30, right: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 40),
            const RatingIcon(width: 150),
            const SizedBox(height: 40),
            Text(AppStrings.ratingStrings.ratingTitle,
                style: textStyle.copyWith(
                    fontSize: 34, fontWeight: FontWeight.w700),
                textAlign: textAlign),
            Container(height: 20),
            Text(AppStrings.ratingStrings.ratingDescription1,
                style: textStyle.copyWith(fontSize: 16), textAlign: textAlign),
            Container(height: 20),
            Text(AppStrings.ratingStrings.ratingDescription2,
                style: textStyle.copyWith(fontSize: 16), textAlign: textAlign),
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 24),
              child: StarDisplayWidget(
                  filledStar:
                      Icon(Icons.star, color: Color(0xFFF7B500), size: 40),
                  unfilledStar: Icon(Icons.star_border, size: 40),
                  value: 5),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: MainButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    onPressed: onRating,
                    title: AppStrings.ratingStrings.ratingButton,
                  ),
                ),
                const SizedBox(height: 8),
                Text(AppStrings.ratingStrings.ratingTakeFewSecond,
                    style: textStyle.copyWith(fontSize: 14))
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: MainButton(
                backgroundColor:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? Colors.transparent
                        : (hasBackground ? Colors.white : Colors.black),
                textColor: Theme.of(context).colorScheme.onSurface,
                onPressed: onFeedback,
                title: AppStrings.ratingStrings.ratingFeedback,
                borderSize:
                    Theme.of(context).colorScheme.brightness == Brightness.dark
                        ? const BorderSide(color: Colors.white54, width: 1)
                        : null,
              ),
            )
          ],
        ),
      ),
    );
  }
}
