import 'package:flutter/material.dart';

class AnimatedShieldScreen extends StatefulWidget {
  final int delayTime;

  const AnimatedShieldScreen({super.key, required this.delayTime});

  @override
  State<AnimatedShieldScreen> createState() => _AnimatedShieldScreenState();
}

class _AnimatedShieldScreenState extends State<AnimatedShieldScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: widget.delayTime + 100),
          () => Navigator.of(context).pop());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: Future.delayed(Duration(milliseconds: widget.delayTime)),
            builder: (_, snapShot) =>
                snapShot.connectionState == ConnectionState.done
                    ? Hero(
                        tag: 'shield',
                        child: Image.asset(
                          'assets/images/animated_shield.png',
                        ),
                      )
                    : SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

class TransparentRoute extends PageRoute<void> {
  TransparentRoute({required this.builder}) : super();

  final WidgetBuilder builder;

  @override
  Color get barrierColor => Colors.transparent;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  String get barrierLabel => 'Dismiss';

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return builder(context);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
