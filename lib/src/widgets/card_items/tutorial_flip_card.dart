import 'dart:async';

import 'package:flutter/material.dart';

class TutorialFlipCard extends StatefulWidget {
  const TutorialFlipCard({super.key});

  @override
  State<StatefulWidget> createState() => _TutorialFlipCardState();
}

class _TutorialFlipCardState extends State<TutorialFlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<Offset>? _animationLeft;
  Animation<Offset>? _animationRight;
  Animation<double>? _animationMiddle;
  int _position = 0;
  Timer? _timer;
  final TextStyle _textStyle = const TextStyle(
      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18);
  final double _fontSize = 20;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _animationMiddle = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 0.7, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.7), weight: 1)
    ]).animate(_controller!);
    _animationLeft = TweenSequence([
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: Offset.zero, end: const Offset(-1.0, 0.0)),
          weight: 1),
      TweenSequenceItem(
          tween:
              Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero),
          weight: 1)
    ]).animate(_controller!);
    _animationRight = TweenSequence([
      TweenSequenceItem(
          tween: Tween<Offset>(begin: Offset.zero, end: const Offset(1.0, 0.0)),
          weight: 1),
      TweenSequenceItem(
          tween: Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero),
          weight: 1)
    ]).animate(_controller!);
    _controller?.repeat(min: 0, max: 1, period: const Duration(seconds: 1));
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _position--;
      if (_position < -1) {
        _position = 1;
      }
      setState(() {
        _position = _position;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _position == 0
        ? _makeMiddle()
        : (_position == 1 ? _makeRight() : _makeLeft());
  }

  Widget _makeLeft() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SlideTransition(
          position: _animationLeft!,
          child:
              Icon(Icons.arrow_back, size: _fontSize, color: _textStyle.color),
        ),
        const SizedBox(width: 8),
        Text("Swipe to study again", style: _textStyle),
      ],
    );
  }

  Widget _makeRight() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Swipe if you learnt it", style: _textStyle),
        const SizedBox(width: 8),
        SlideTransition(
          position: _animationRight!,
          child: Icon(Icons.arrow_forward,
              size: _fontSize, color: _textStyle.color),
        ),
      ],
    );
  }

  Widget _makeMiddle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ScaleTransition(
          scale: _animationMiddle!,
          child:
              Icon(Icons.touch_app, size: _fontSize, color: _textStyle.color),
        ),
        const SizedBox(width: 8),
        Text("Tap to flip card", style: _textStyle),
      ],
    );
  }
}
