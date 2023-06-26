import 'package:flutter/material.dart';

class TextAnimation extends StatefulWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  const TextAnimation(
    this.text, {
    Key? key,
    required this.style,
    required this.textAlign,
  }) : super(key: key);

  @override
  State<TextAnimation> createState() => TextAnimationState();
}

class TextAnimationState extends State<TextAnimation>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String get _text => widget.text;
  List<GlobalKey<_LetterAnimationState>> _keys = [];

  void onRefresh() {
    for (GlobalKey<_LetterAnimationState> key in _keys) {
      key.currentState?.onAnimated();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    int duration = 100;
    _keys = [];
    return Wrap(
      direction: Axis.horizontal,
      children: _text.split(" ").map((word) {
        GlobalKey<_LetterAnimationState> key =
            GlobalKey(debugLabel: "$duration");
        _keys.add(key);
        return _LetterAnimation("$word ",
            duration: duration += 50,
            textAlign: widget.textAlign,
            style: widget.style,
            key: key);
      }).toList(),
    );
  }
}

class _LetterAnimation extends StatefulWidget {
  final String text;
  final int duration;
  final TextStyle style;
  final TextAlign textAlign;

  const _LetterAnimation(
    this.text, {
    Key? key,
    this.duration = 200,
    required this.style,
    required this.textAlign,
  }) : super(key: key);

  @override
  State<_LetterAnimation> createState() => _LetterAnimationState();
}

class _LetterAnimationState extends State<_LetterAnimation>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late AnimationController _animationController1;
  late AnimationController _animationController2;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController1 = AnimationController(
        duration: Duration(milliseconds: widget.duration), vsync: this);
    _animationController2 = AnimationController(
        duration: Duration(milliseconds: widget.duration * 2), vsync: this);
    _slideAnimation = _animationController1.drive(Tween<Offset>(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ));
    _opacityAnimation = _animationController2.drive(Tween<double>(
      begin: 0,
      end: 1,
    ));
    onAnimated();
  }

  @override
  void dispose() {
    _animationController1.dispose();
    _animationController2.dispose();
    super.dispose();
  }

  void onAnimated() {
    _animationController1.reset();
    _animationController1.forward();
    _animationController2.reset();
    _animationController2.forward();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child:
            Text(widget.text, textAlign: widget.textAlign, style: widget.style),
      ),
    );
  }
}
