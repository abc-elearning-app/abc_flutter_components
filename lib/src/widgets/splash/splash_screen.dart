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

class _SplashScreenComponentState extends State<SplashScreenComponent> with TickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> scaleAnimation;
  late Animation<double> boxAnimation;
  late Animation<double> starAnimation;
  late Animation<double> textAnimation;
  late Animation<double> textOpacityAnimation;
  late Animation<double> rotateAnimation;
  late List<Animation<double>> characterAnimation;

  late AnimationController textController;
  late List<Animation<double>> textAnimations;

  bool isDismissing = false;

  @override
  void initState() {
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 2400));
    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 4 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 16 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 4 / 24),
    ]).animate(controller);
    boxAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 9 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -30), weight: 4 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(-30), weight: 11 / 24),
    ]).animate(controller);
    starAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: -500, end: 0).chain(CurveTween(curve: Curves.bounceOut)), weight: 8 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 1 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: -30), weight: 4 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(-30), weight: 11 / 24),
    ]).animate(controller);
    textAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 9 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 70), weight: 4 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(70), weight: 11 / 24),
    ]).animate(controller);
    textOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 8 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: 1), weight: 5 / 24),
      TweenSequenceItem(tween: ConstantTween<double>(1), weight: 7 / 24),
      TweenSequenceItem(tween: Tween<double>(begin: 1, end: 0), weight: 4 / 24),
    ]).animate(controller);
    rotateAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween<double>(0), weight: 20 / 22),
      TweenSequenceItem(tween: Tween<double>(begin: 0, end: pi / 2), weight: 2 / 22),
    ]).animate(controller);
    characterAnimation = List.generate(
        widget.appName.length,
        (index) => Tween<double>(begin: 0, end: -30).animate(CurvedAnimation(
              parent: controller,
              curve: Interval(
                ((20 / 24) + (index * (1 / 24))).clamp(0, 1),
                ((20 / 24) + (index * (1 / 24)) + 3 / 22).clamp(0, 1),
              ),
            )));

    Future.delayed(const Duration(milliseconds: 2200), () {
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
    return Center(
      child: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(widget.background),
            fit: BoxFit.fitHeight,
          )),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          color: isDismissing ? widget.backgroundColor : widget.secondaryColor.withOpacity(0.9),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // App name
                AnimatedBuilder(
                    animation: Listenable.merge([textAnimation, ...characterAnimation]),
                    builder: (_, __) => Visibility(
                          visible: textAnimation.value != 0,
                          child: Transform.translate(
                            offset: Offset(0, textAnimation.value),
                            child: Material(
                                color: Colors.transparent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      widget.appName.length,
                                      (index) => Opacity(
                                            opacity: textOpacityAnimation.value,
                                            child: Transform.translate(
                                              offset: Offset(0, characterAnimation[index].value),
                                              child: Text(widget.appName[index],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 40,
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                            ),
                                          )),
                                )),
                          ),
                        )),

                // Box
                AnimatedBuilder(
                  animation: Listenable.merge([boxAnimation, rotateAnimation]),
                  builder: (_, __) => Transform.translate(
                    offset: Offset(0, boxAnimation.value),
                    child: Transform.rotate(
                      angle: rotateAnimation.value,
                      child: ScaleTransition(
                        scale: scaleAnimation,
                        child: IconWidget(
                          icon: widget.box,
                          height: 150,
                        ),
                      ),
                    ),
                  ),
                ),

                // Star
                AnimatedBuilder(
                    animation: Listenable.merge([starAnimation, rotateAnimation]),
                    builder: (_, __) => Transform.translate(
                          offset: Offset(0, starAnimation.value),
                          child: Transform.rotate(
                            angle: rotateAnimation.value,
                            child: ScaleTransition(
                              scale: scaleAnimation,
                              child: IconWidget(
                                icon: widget.star,
                                height: 120,
                              ),
                            ),
                          ),
                        ))
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
