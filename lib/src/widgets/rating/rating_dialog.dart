import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';
import 'package:flutter_abc_jsc_components/src/widgets/rating/star_line.dart';

class RatingDialogComponent extends StatefulWidget {
  final Color mainColor;
  final Color backgroundColor;
  final bool isDarkMode;

  final String backgroundImage;
  final String image;
  final List<String> starImages;
  final String unselectedStarImage;

  final void Function(int starCount) onRate;

  const RatingDialogComponent({
    super.key,
    required this.mainColor,
    required this.backgroundColor,
    required this.isDarkMode,
    required this.backgroundImage,
    required this.image,
    required this.onRate,
    required this.starImages,
    required this.unselectedStarImage,
  });

  @override
  State<RatingDialogComponent> createState() => _RatingDialogComponentState();
}

class _RatingDialogComponentState extends State<RatingDialogComponent> {
  late ValueNotifier<int> _starRated;
  bool isSelected = false;

  @override
  void initState() {
    _starRated = ValueNotifier(0);
    super.initState();
  }

  @override
  void dispose() {
    _starRated.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: widget.isDarkMode ? Colors.black : widget.backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Wrap(children: [
          Stack(children: [
            // Background image
            Image.asset(widget.backgroundImage),

            // Close button
            Positioned(
              top: 5,
              right: 5,
              child: IconButton(
                icon: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey.shade100,
                  child: Icon(
                    Icons.close_outlined,
                    color: widget.mainColor,
                    size: 18,
                  ),
                ),
                onPressed: Navigator.of(context).pop,
              ),
            ),

            // Main content
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Main image
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: Image.asset(
                    widget.image,
                    width: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "We're Like The FOMO Of Apps:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    "You'll Miss Out If You Don't Leave Us A Positive Rating.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: widget.isDarkMode ? Colors.white : Colors.black),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: StarLineWidget(
                    isDarkMode: widget.isDarkMode,
                    starImages: widget.starImages,
                    unselectedStarImage: widget.unselectedStarImage,
                    onSelect: _handleSelectStar,
                  ),
                ),

                // Action buttons
                ValueListenableBuilder(
                  valueListenable: _starRated,
                  builder: (_, star, __) => Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: MainButton(
                      borderRadius: 36,
                      title: star > 3 || star == 0
                          ? 'Rate us on the Playstore'
                          : 'Feedback',
                      backgroundColor: widget.mainColor,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      disabled: !isSelected,
                      disabledColor: widget.isDarkMode
                          ? Colors.grey
                          : Colors.black.withOpacity(0.08),
                      textColor: widget.isDarkMode
                          ? Colors.white
                          : !isSelected
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      onPressed: () => widget.onRate(_starRated.value),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                    bottom: 5,
                  ),
                  child: MainButton(
                    backgroundColor: Colors.transparent,
                    borderRadius: 36,
                    textColor: widget.isDarkMode
                        ? Colors.white.withOpacity(0.5)
                        : Colors.black.withOpacity(0.5),
                    title: 'Not now',
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ]),
        ]),
      ),
    );
  }

  _handleSelectStar(int star) {
    _starRated.value = star;
    if (!isSelected) {
      setState(() => isSelected = true);
    }
  }
}
