import 'dart:math';
import 'package:flutter/material.dart';

class FlipCardController {
  late Function onReset;
}

enum FlipDirection {
  vertical,
  horizontal,
}

class AnimationCard extends StatelessWidget {
  const AnimationCard({
    super.key,
    required this.child,
    required this.animation,
    required this.direction,
  });

  final Widget child;
  final Animation<double> animation;
  final FlipDirection direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, child) {
        var transform = Matrix4.identity();
        transform.setEntry(3, 2, 0.001);
        if (direction == FlipDirection.vertical) {
          transform.rotateX(animation.value);
        } else {
          transform.rotateY(animation.value);
        }
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

typedef BoolCallback = void Function(bool isFront);

class FlipCardItem extends StatefulWidget {
  final Widget front;
  final Widget back;

  final int speed;
  final FlipDirection direction;
  final VoidCallback onFlip;
  final BoolCallback onFlipDone;
  final FlipCardController controller;
  final bool flipOnTouch;

  const FlipCardItem({
    super.key,
    required this.front,
    required this.back,
    this.speed = 500,
    required this.onFlip,
    required this.onFlipDone,
    this.direction = FlipDirection.horizontal,
    this.flipOnTouch = true,
    required this.controller,
  });

  @override
  State<StatefulWidget> createState() {
    return FlipCardItemState();
  }
}

class FlipCardItemState extends State<FlipCardItem>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> _frontRotation;
  late Animation<double> _backRotation;

  bool isFront = true;

  bool get flipOnTouch => widget.flipOnTouch;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: widget.speed), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.onFlipDone(isFront);
      }
    });
    widget.controller.onReset = () {
      if (!isFront) {
        controller.reverse(from: 0);
        setState(() {
          isFront = true;
        });
      }
    };
  }

  void toggleCard() {
    widget.onFlip();
    if (isFront) {
      controller.forward();
    } else {
      controller.reverse();
    }

    setState(() {
      isFront = !isFront;
    });
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      fit: StackFit.passthrough,
      children: <Widget>[
        _buildContent(front: true),
        _buildContent(front: false),
      ],
    );

    if (flipOnTouch) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: toggleCard,
        child: child,
      );
    }
    return child;
  }

  Widget _buildContent({required bool front}) {
    return IgnorePointer(
      ignoring: front ? !isFront : isFront,
      child: AnimationCard(
        animation: front ? _frontRotation : _backRotation,
        direction: widget.direction,
        child: front ? widget.front : widget.back,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
