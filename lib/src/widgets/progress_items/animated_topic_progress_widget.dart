import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/main_icon.dart';

class AppBarProgressItem {
  String title;
  String value;
  Color? color;
  IconData? icon;

  AppBarProgressItem({
    this.icon,
    required this.title,
    required this.value,
    this.color,
  });
}

class AnimatedTopicProgressWidget extends StatefulWidget {
  final bool animation;
  final double? height;
  final double progress;
  final List<AppBarProgressItem> progressItems;

  const AnimatedTopicProgressWidget({
    super.key,
    required this.progress,
    required this.progressItems,
    this.height,
    this.animation = true,
  });

  @override
  State<AnimatedTopicProgressWidget> createState() =>
      _AnimatedTopicProgressWidgetState();
}

class _AnimatedTopicProgressWidgetState
    extends State<AnimatedTopicProgressWidget>
    with SingleTickerProviderStateMixin {
  Animation<int>? _animation;
  AnimationController? _controller;
  final Map<String, Animation<double>> _animations = {};

  @override
  void initState() {
    super.initState();
    if (widget.animation == true) {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 1000), vsync: this);
      _animation = IntTween(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeOut));
      for (var element in widget.progressItems) {
        _animations[element.title] = CurvedAnimation(
            parent: _controller!,
            curve: const Interval(0.2, 1.0, curve: Curves.bounceOut));
      }
      _controller?.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animations.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          widget.progress != null ? _makeLineProgress() : const SizedBox(),
          _makeInfoProgress()
        ],
      ),
    );
  }

  Widget _makeLineProgress() {
    Size size = MediaQuery.of(context).size;
    double width = size.width - 32 * 2;
    return SizedBox(
      width: size.width,
      height: 55,
      child: _makeLineContent(width),
    );
  }

  Widget _makeLineContent(double width) {
    if (_animation == null) {
      return _makeLineChildContent(width, widget.progress.round().toInt(), 1);
    }
    return AnimatedBuilder(
        animation: _animation!,
        builder: (context, child) {
          double value = _controller?.value ?? 1;
          return _makeLineChildContent(
              width, (widget.progress.round() * value).toInt(), value);
        });
  }

  Widget _makeLineChildContent(double width, int flex, double value) {
    return Stack(
      children: <Widget>[
        Positioned(
            width: 32,
            height: 47,
            top: 0,
            left: ((widget.progress * width) / 100 + 16) * value,
            child: const Stack(
              children: <Widget>[
                MainIcon(
                    icon: Icon(Icons.directions_bus,
                        color: Colors.white, size: 16),
                    size: 32,
                    useDefault: true),
                Positioned(
                    bottom: 5,
                    left: 7,
                    child: Icon(Icons.arrow_drop_down,
                        color: Colors.white, size: 18))
              ],
            )),
        Positioned(
            width: width,
            height: 8,
            top: 38,
            left: 32,
            child: Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      flex: flex,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xFF96D9FF),
                                Theme.of(context).colorScheme.secondary
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight),
                        ),
                      )),
                  Expanded(flex: 100 - flex, child: const SizedBox())
                ],
              ),
            ))
      ],
    );
  }

  Widget _makeInfoProgress() {
    List<Widget> widgets = [];
    for (var item in widget.progressItems) {
      widgets.add(_makeTitleProgress(
        title: item.title,
        value: item.value,
        icon: item.icon,
        color: item.color,
        animation: _animations[item.title]!,
      ));
      widgets.add(_makeBorderProgress());
    }
    widgets.removeLast();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }

  Widget _makeTitleProgress({
    String title = '',
    String value = '',
    IconData? icon,
    required Animation<double> animation,
    Color? color,
  }) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    TextStyle style = TextStyle(
      color: color,
      fontSize: 13 / textScaleFactor,
      fontWeight: FontWeight.w500,
      height: 1.4,
    );
    Widget child;
    child = icon != null
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(value.toString(),
                  style: style.copyWith(
                      fontSize: 16 / textScaleFactor, color: color),
                  textAlign: TextAlign.center),
              Icon(icon, color: color, size: 15)
            ],
          )
        : Text(value.toString(),
            style: style.copyWith(fontSize: 16 / textScaleFactor, color: color),
            textAlign: TextAlign.center);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title, style: style, textAlign: TextAlign.center),
        animation != null
            ? ScaleTransition(scale: animation, child: child)
            : child
      ],
    );
  }

  Widget _makeBorderProgress() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 52,
      width: 2,
      color: Colors.white.withOpacity(0.3),
    );
  }
}
