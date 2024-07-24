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
        (_) => AnimationController(
              vsync: this,
              duration: const Duration(milliseconds: 300),
            ));
    starAnimations = List.generate(
        5,
        (index) => Tween<double>(
              begin: 0.7,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                  child: GestureDetector(
                    onTap: () => _handleSelection(id),
                    child: ScaleTransition(
                      scale: starAnimations[id],
                      child: IconWidget(
                        icon: _getIcon(id),
                        color: _getColor(id),
                        width: 35,
                      ),
                    ),
                  ),
                )),
      ),
    );
  }

  _getIcon(int id) =>
      selectedStars <= id ? widget.unselectedStarImage : widget.starImages[id];

  _getColor(int id) =>
      selectedStars <= id && widget.isDarkMode ? Colors.white : null;

  _handleSelection(int id) {
    setState(() => selectedStars = id + 1);

    for (int i = 0; i < 5; i++) {
      if (i < selectedStars) {
        Future.delayed(Duration(milliseconds: 50 * i), () {
          if (mounted) {
            starControllers[i].forward();
          }
        });
      } else {
        Future.delayed(Duration(milliseconds: 50 * (5 - i)), () {
          if (mounted) {
            starControllers[i].reverse();
          }
        });
      }
    }

    widget.onSelect(selectedStars);
  }
}
