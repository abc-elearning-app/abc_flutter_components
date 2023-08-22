import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/icons/main_icon.dart';

class AnimatedAppBarProgressItem {
  String title;
  String value;
  IconData? icon;

  AnimatedAppBarProgressItem({
    this.icon,
    required this.title,
    required this.value,
  });
}

class TopicProgressWidget extends StatefulWidget {
  final bool animation;
  final double? height;
  final double progress;
  final List<AnimatedAppBarProgressItem> progressItems;
  final String testBackgroundPath;

  const TopicProgressWidget({
    super.key,
    required this.progress,
    required this.progressItems,
    this.height,
    this.animation = true,
    required this.testBackgroundPath,
  });

  @override
  State<TopicProgressWidget> createState() => _TopicProgressWidgetState();
}

class _TopicProgressWidgetState extends State<TopicProgressWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      alignment: Alignment.center,
      child: _makeInfoProgress(),
    );
  }

  Widget _makeInfoProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            widget.testBackgroundPath,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.progressItems
            .map((item) => _makeTitleProgress(
                  title: item.title,
                  value: item.value,
                  icon: item.icon,
                ))
            .toList(),
      ),
    );
  }

  Widget _makeTitleProgress(
      {String title = '', String value = '', IconData? icon}) {
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    TextStyle style = TextStyle(
      color: const Color(0xFF212121),
      fontSize: 13 / textScaleFactor,
      height: 1.4,
    );
    Widget child;
    if (icon != null) {
      child = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(value.toString(),
              style: style.copyWith(
                fontSize: 16 / textScaleFactor,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF212121),
              ),
              textAlign: TextAlign.center),
          Icon(icon, color: const Color(0xFF0C1827), size: 15)
        ],
      );
    } else {
      child = Text(value.toString(),
          style: style.copyWith(
            fontSize: 16 / textScaleFactor,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF212121),
          ),
          textAlign: TextAlign.center);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(title, style: style, textAlign: TextAlign.center),
        child
      ],
    );
  }
}

class BottomAppBarProgress extends StatefulWidget {
  final bool animation;
  final double progress;
  final bool icon;

  const BottomAppBarProgress(
      {super.key,
      required this.animation,
      required this.progress,
      this.icon = true});

  @override
  State<BottomAppBarProgress> createState() => _BottomAppBarProgressState();
}

class _BottomAppBarProgressState extends State<BottomAppBarProgress>
    with SingleTickerProviderStateMixin {
  Animation<int>? _animation;
  AnimationController? _controller;
  final double iconSize = 32;

  @override
  void initState() {
    super.initState();
    if (widget.animation == true) {
      _controller = AnimationController(
          duration: const Duration(milliseconds: 1000), vsync: this);
      _animation = IntTween(begin: 1, end: 0).animate(
          CurvedAnimation(parent: _controller!, curve: Curves.easeOut));
      _controller?.forward();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _makeLineProgress();
  }

  Widget _makeLineProgress() {
    Size size = MediaQuery.of(context).size;
    double width = size.width - iconSize * 2;
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
        widget.icon
            ? Positioned(
                width: iconSize,
                height: 47,
                top: 0,
                left: ((widget.progress * width) / 100 + 16) * value,
                child: Stack(
                  children: <Widget>[
                    MainIcon(
                      icon: const Icon(Icons.directions_bus,
                          color: Colors.white, size: 16),
                      size: iconSize,
                      useDefault: true,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const Positioned(
                        bottom: 5,
                        left: 7,
                        child: Icon(Icons.arrow_drop_down,
                            color: Colors.white, size: 18))
                  ],
                ))
            : const SizedBox(),
        Positioned(
            width: width,
            height: 8,
            top: 38,
            left: iconSize,
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
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                                Theme.of(context).colorScheme.primary,
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
}
