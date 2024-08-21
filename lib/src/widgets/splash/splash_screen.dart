import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/flutter_abc_jsc_components.dart';

class SplashScreenComponent extends StatefulWidget {
  final Color secondaryColor;
  final Color backgroundColor;
  final String background;
  final String box;
  final String star;

  final String appName;

  const SplashScreenComponent({
    super.key,
    required this.secondaryColor,
    required this.background,
    required this.box,
    required this.star,
    required this.appName,
    required this.backgroundColor,
  });

  @override
  State<SplashScreenComponent> createState() => _SplashScreenComponentState();
}

class _SplashScreenComponentState extends State<SplashScreenComponent> with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> scaleBoxAnimation;
  late Animation<double> scaleStarAnimation;
  late Animation<double> rotateAnimation;
  late Animation<double> textAnimation;
  late Animation<double> bgOpacityAnimation;

  bool isDismissing = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    scaleBoxAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 5 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 3 / 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.85).chain(CurveTween(curve: Curves.easeOut)), weight: 5 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(0.85), weight: 7 / 20),
    ]).animate(controller);

    scaleStarAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 2 / 18),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 4 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 1 / 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0.85).chain(CurveTween(curve: Curves.easeIn)), weight: 5 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(0.85), weight: 8 / 20),
    ]).animate(controller);

    textAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(-50), weight: 9 / 20),
      TweenSequenceItem(tween: Tween<double>(begin: -50, end: -10).chain(CurveTween(curve: Curves.easeOut)), weight: 6 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(-10), weight: 5 / 20),
    ]).animate(controller);

    rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: -pi / 4, end: 0).chain(CurveTween(curve: Curves.easeOut)), weight: 4 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 16 / 20),
    ]).animate(controller);

    bgOpacityAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1).chain(CurveTween(curve: Curves.easeOut)), weight: 10 / 20),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 8 / 20),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0).chain(CurveTween(curve: Curves.easeOut)), weight: 2 / 20),
    ]).animate(controller);

    Future.delayed(const Duration(milliseconds: 1800), () {
      setState(() => isDismissing = true);
    });

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: [
      Positioned.fill(
        child: AnimatedBuilder(
          animation: bgOpacityAnimation,
          builder: (_, __) => Opacity(
            opacity: bgOpacityAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                  color: widget.secondaryColor,
                  image: DecorationImage(
                    image: AssetImage(widget.background),
                    opacity: 0.2,
                    fit: BoxFit.fitHeight,
                  )),
            ),
          ),
        ),
      ),
      Positioned.fill(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [_buildLogoBackground(), _buildLogoForeground()],
            ),
            _buildAppName(),
          ],
        ),
      ),
      Positioned.fill(
          child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isDismissing ? widget.backgroundColor : Colors.transparent,
      ))
    ]);
  }

  _buildAppName() => ClipRect(
        child: AnimatedBuilder(
            animation: textAnimation,
            builder: (_, __) => Transform.translate(
                offset: Offset(0, textAnimation.value),
                child: Material(
                  color: Colors.transparent,
                  child: Text(widget.appName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                      )),
                ))),
      );

  _buildLogoBackground() => AnimatedBuilder(
        animation: rotateAnimation,
        builder: (_, __) => Transform.rotate(
          angle: rotateAnimation.value,
          child: ScaleTransition(
            scale: scaleBoxAnimation,
            child: IconWidget(
              icon: widget.box,
              height: 120,
            ),
          ),
        ),
      );

  _buildLogoForeground() => AnimatedBuilder(
      animation: Listenable.merge([scaleStarAnimation, rotateAnimation]),
      builder: (_, __) => ScaleTransition(
            scale: scaleStarAnimation,
            child: IconWidget(
              icon: widget.star,
              height: 80,
            ),
          ));
}
