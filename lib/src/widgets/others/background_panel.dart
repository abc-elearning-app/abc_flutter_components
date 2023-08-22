import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/constants/configs.dart';

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
    return Container(
      decoration: BoxDecoration(
        image: !isDarkMode
            ? DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                    backgroundImage ?? "assets/images/background_image.jpg",
                    package: backgroundImage != null ? null : appPackage))
            : null,
        color: Theme.of(context).colorScheme.surface,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
