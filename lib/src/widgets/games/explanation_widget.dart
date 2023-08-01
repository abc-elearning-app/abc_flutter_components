import 'package:flutter/material.dart';

import '../../../flutter_abc_jsc_components.dart';
import '../../../models/constraints.dart';

class ExplanationWidget extends StatefulWidget {
  final String explanation;
  final String? hintImage;
  final double fontSize;
  final bool show;
  final bool animation;
  final String? title;

  const ExplanationWidget({
    super.key,
    this.fontSize = CONFIG_FONT_SIZE_DEFAULT,
    this.show = false,
    this.explanation = '',
    this.hintImage,
    this.animation = true,
    this.title,
  });

  @override
  State<ExplanationWidget> createState() => _ExplanationWidgetState();
}

class _ExplanationWidgetState extends State<ExplanationWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _expandController;
  Animation<double>? _animation;
  bool open = false;
  bool disposed = false;

  bool get hasAnimation => widget.animation;

  @override
  void initState() {
    disposed = false;
    super.initState();
    open = widget.show;
    // print("widget.show ${widget.show}");
    prepareAnimations();
    _runExpandCheck();
  }

  void _runExpandCheck() {
    if (disposed) {
      return;
    }
    if (!hasAnimation) {
      return;
    }
    Future.microtask(() {
      _expandController?.reset();
      _expandController?.forward();
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    disposed = true;
    if (hasAnimation) {
      _expandController?.dispose();
    }
    super.dispose();
  }

  void prepareAnimations() {
    if (!hasAnimation) {
      return;
    }
    _expandController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _animation = CurvedAnimation(
      parent: _expandController!,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.explanation.isEmpty) {
      return const SizedBox();
    }
    if (hasAnimation) {
      return SizeTransition(
        axisAlignment: 1.0,
        sizeFactor: _animation!,
        child: _makeContent(),
      );
    }
    return _makeContent();
  }

  bool get _darkMode => Theme.of(context).brightness == Brightness.dark;

  Widget _makeButtonExplanation() {
    if (widget.show == true || widget.title == null || widget.title!.isEmpty) {
      return const SizedBox();
    }
    return InkWell(
      child: SizedBox(
        width: double.infinity,
        child: Text(open ? AppStrings.gameStrings.gameHide : widget.title!,
            textAlign: TextAlign.start,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: Colors.lightBlue)),
      ),
      onTap: () {
        setState(() {
          open = !open;
        });
        _runExpandCheck();
      },
    );
  }

  Widget _makeContent() {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // open ?
          TextContent(
              widget.explanation,
              TextAlign.start,
              TextStyle(
                  color: _darkMode ? Colors.white : const Color(0xFF4D4D4D),
                  fontSize: widget.fontSize,
                  fontStyle: FontStyle.italic))
          // : SizedBox(),
          // Padding(
          //   padding: EdgeInsets.only(top: open ? 8 : 0,bottom: 12),
          //   child: _makeButtonExplanation(),
          // ),
        ]);
  }
}
