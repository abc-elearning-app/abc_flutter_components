import 'package:flutter/material.dart';

class LinearProgress extends StatelessWidget {
  final num value;
  final Color? backgroundColor;
  final Color? valueColor;
  final double minHeight;
  final String? label;
  final Color textColor;

  const LinearProgress({
    super.key,
    required this.value,
    this.backgroundColor,
    this.valueColor,
    required this.minHeight,
    this.label,
    required this.textColor,
  });

  final double labelSize = 50;

  @override
  Widget build(BuildContext context) {
    num progressValue = value;
    // double _value = 0.8;
    if (progressValue < 0 || progressValue > 1.0) {
      // print("LinearProgress value >= 0 && value <= 1.0");
    }
    if (progressValue > 1) {
      progressValue = 1;
    }
    if (progressValue < 0) {
      progressValue = 0;
    }
    int progress = (progressValue * 100).toInt();
    if (label != null && label!.isNotEmpty) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: _makeContent(progress, context)),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              label!,
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          )
        ],
      );
    }
    return _makeContent(progress, context);
  }

  Widget _makeContent(int progress, BuildContext context) {
    return Container(
      width: double.infinity,
      height: minHeight,
      decoration: BoxDecoration(
          color: backgroundColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF8c8c8c)
                  : const Color(0xFFe4e4e4)),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 500),
              tween: IntTween(begin: 0, end: progress),
              builder: (context, value, child) {
                return Expanded(
                  flex: value,
                  child: Container(
                    height: minHeight,
                    decoration: BoxDecoration(
                        color: valueColor ??
                            (Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF212121)
                                : Theme.of(context).colorScheme.primary),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
          Expanded(
            flex: 100 - progress,
            child: SizedBox(
              height: minHeight,
            ),
          ),
        ],
      ),
    );
  }
}

class LinearProgress2 extends StatelessWidget {
  final int value1;
  final int value2;
  final Color? backgroundColor;
  final Color? valueColor1;
  final Color? valueColor2;
  final double minHeight;
  final int total;

  const LinearProgress2({
    super.key,
    required this.total,
    required this.value1,
    required this.value2,
    this.backgroundColor,
    this.valueColor1,
    required this.minHeight,
    this.valueColor2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: minHeight,
      decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFe4e4e4),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 500),
              tween: IntTween(begin: 0, end: value1 * 10),
              builder: (context, value, child) {
                return Expanded(
                  flex: value,
                  child: Container(
                    height: minHeight,
                    decoration: BoxDecoration(
                        color: valueColor1 ?? const Color(0xFF00E291),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
          TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 500),
              tween: IntTween(begin: 0, end: value2 * 10),
              builder: (context, value, child) {
                return Expanded(
                  flex: value,
                  child: Container(
                    height: minHeight,
                    decoration: BoxDecoration(
                        color: valueColor2 ?? const Color(0xFFEBAD34),
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
          TweenAnimationBuilder<int>(
              duration: const Duration(milliseconds: 500),
              tween: IntTween(begin: 0, end: (total - value1 - value2) * 10),
              builder: (context, value, child) {
                return Expanded(
                  flex: value,
                  child: const SizedBox(),
                );
              }),
        ],
      ),
    );
  }
}
