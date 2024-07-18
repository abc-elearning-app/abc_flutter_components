import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class StarLineWidget extends StatefulWidget {
  final List<String> starImages;
  final String unselectedStarImage;

  final bool isDarkMode;

  final void Function(int star) onSelect;

  const StarLineWidget({
    super.key,
    required this.starImages,
    required this.onSelect,
    required this.unselectedStarImage,
    required this.isDarkMode,
  });

  @override
  State<StarLineWidget> createState() => _StarLineWidgetState();
}

class _StarLineWidgetState extends State<StarLineWidget>
    with TickerProviderStateMixin {
  int selectedStars = 0;

  late List<AnimationController> starControllers;
  late List<Animation<double>> starAnimations;

  @override
  void initState() {
    starControllers = List.generate(
        5,
        (id) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            ));
    starAnimations = List.generate(
        5,
        (index) => Tween<double>(
              begin: 0.8,
              end: 1,
            ).animate(starControllers[index]));
    super.initState();
  }

  @override
  void dispose() {
    for (AnimationController starController in starControllers) {
      starController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            widget.starImages.length,
            (id) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: Opacity(
                    opacity: selectedStars >= id + 1 ? 1 : 0.5,
                    child: GestureDetector(
                      onTap: () => _handleSelection(id),
                      child: ScaleTransition(
                        scale: starAnimations[id],
                        child: IconWidget(
                          icon: selectedStars <= id
                              ? widget.unselectedStarImage
                              : widget.starImages[id],
                          color: selectedStars <= id
                              ? widget.isDarkMode
                                  ? Colors.white
                                  : null
                              : null,
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  _handleSelection(int id) {
    setState(() {
      selectedStars = id + 1;

      for (int i = 0; i < selectedStars; i++) {
        Future.delayed(Duration(milliseconds: 30 * i), () {
          if (mounted) {
            starControllers[i].forward();
          }
        });
      }
      for (int i = 4; i >= selectedStars; i--) {
        Future.delayed(Duration(milliseconds: 20 * (5 - i)), () {
          if (mounted) {
            starControllers[i].reverse();
          }
        });
      }
    });

    widget.onSelect(selectedStars);
  }
}
