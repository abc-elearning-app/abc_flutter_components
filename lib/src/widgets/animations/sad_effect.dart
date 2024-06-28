import 'package:flutter/material.dart';

class SadEffect extends StatefulWidget {
  final double height;

  const SadEffect({
    super.key,
    this.height = 250,
  });

  @override
  State<SadEffect> createState() => _SadEffectState();
}

class _SadEffectState extends State<SadEffect> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    animation = Tween<double>(begin: 0, end: 1).animate(controller);

    fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(fadeController);

    controller.forward();
    Future.delayed(const Duration(seconds: 1), (){
      fadeController.forward();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: fadeController,
      builder: (_, __) => Opacity(
        opacity: 1 - fadeController.value,
        child: SizedBox(
          height: widget.height,
          child: Stack(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                  5,
                  (index) => AnimatedBuilder(
                        animation: controller,
                        builder: (_, __) => Container(
                            height: _getBarHeight(index, widget.height, controller),
                            width: 3,
                            decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10)))),
                      )),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: AnimatedBuilder(
                animation: controller,
                builder: (_, __) => Container(
                  width: double.infinity,
                  height: 100 * controller.value,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 30),
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 20,
                    )
                  ]),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }

  _getBarHeight(int index, double height, AnimationController controller) {
    double lengthRatio = 0;
    switch (index) {
      case 0:
        lengthRatio = 0.5;
        break;
      case 1:
        lengthRatio = 0.2;
        break;
      case 2:
        lengthRatio = 0.3;
        break;
      case 3:
        lengthRatio = 0.5;
        break;
      case 4:
        lengthRatio = 0.7;
        break;
    }
    return height * controller.value * lengthRatio;
  }
}
