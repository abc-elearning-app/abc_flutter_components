import 'package:flutter/material.dart';

class BackgroundPanel extends StatelessWidget {
  final Widget? child;
  final String? backgroundImage;
  final BorderRadius? radius;
  final bool isDarkMode;

  const BackgroundPanel({
    super.key,
    this.radius,
    this.child,
    this.backgroundImage,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    String background =
        backgroundImage ?? "assets/static/apps/background-image.jpg";
    return Container(
      decoration: BoxDecoration(
        image: !isDarkMode && background.isNotEmpty
            ? DecorationImage(fit: BoxFit.fill, image: AssetImage(background))
            : null,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
