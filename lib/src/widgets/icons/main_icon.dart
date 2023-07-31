import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_abc_jsc_components/src/widgets/index.dart';

enum RotateType {
  TOP_CENTER,
  TOP_LEFT,
  TOP_RIGHT,
  CENTER_LEFT,
  CENTER,
  CENTER_RIGHT,
  BOTTOM_LEFT,
  BOTTOM_CENTER,
  BOTTOM_RIGHT,
}

enum IconType {
  /// Hình tròn
  CIRCLE_SHAPE,

  /// Hình vuông
  SQUARE_SHAPE,

  /// Hình thoi
  RHOMBUS_SHAPE,

  /// Hình bình hành
  PARALLELOGRAM_SHAPE,

  /// Hình giọt nước
  TEARDROP_SHAPE,

  /// Hình lục giác
  POLYGON_SHAPE,
}

class MainIcon extends StatelessWidget {
  final double size;
  final Widget icon;
  final Color? color;
  final LinearGradient? linearGradient;
  final LinearGradient? linearGradientIcon;
  final bool useDefault;
  final IconType iconType;
  final RotateType rotateType;

  const MainIcon({
    super.key,
    this.size = 50,
    required this.icon,
    this.color,
    this.useDefault = false,
    this.iconType = IconType.CIRCLE_SHAPE,
    this.linearGradient,
    this.linearGradientIcon,
    this.rotateType = RotateType.TOP_LEFT,
  });

  Color get _startColor =>
      color != null ? color!.withOpacity(0.7) : const Color(0xFF3A95DC);

  Color get _endColor => color ?? const Color(0xFF96D9FF);

  LinearGradient linearGradientIn(BuildContext context) {
    if (Theme.of(context).colorScheme.brightness == Brightness.dark &&
        color == null &&
        !useDefault) {
      return const LinearGradient(
        colors: [Color(0xFF3C444A), Color(0xFF273b4e)],
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
      );
    }
    return LinearGradient(
        colors: [_startColor, _endColor],
        begin: Alignment.centerLeft,
        end: Alignment.topRight);
  }

  BorderRadius _shape(IconType iconType, RotateType rotateType, double size) {
    if (iconType == IconType.CIRCLE_SHAPE) {
      return BorderRadius.circular(size);
    }
    if (iconType == IconType.PARALLELOGRAM_SHAPE) {
      return BorderRadius.only(
          topLeft: const Radius.circular(0),
          bottomLeft: Radius.circular(size / 2),
          bottomRight: const Radius.circular(0),
          topRight: Radius.circular(size / 2));
    }
    if (iconType == IconType.TEARDROP_SHAPE) {
      switch (rotateType) {
        case RotateType.TOP_LEFT:
          return BorderRadius.only(
              topLeft: const Radius.circular(0),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
        case RotateType.TOP_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: const Radius.circular(0));
        case RotateType.BOTTOM_RIGHT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: Radius.circular(size),
              bottomRight: const Radius.circular(0),
              topRight: Radius.circular(size));
        case RotateType.BOTTOM_LEFT:
          return BorderRadius.only(
              topLeft: Radius.circular(size),
              bottomLeft: const Radius.circular(0),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
        default:
          return BorderRadius.only(
              topLeft: const Radius.circular(0),
              bottomLeft: Radius.circular(size),
              bottomRight: Radius.circular(size),
              topRight: Radius.circular(size));
      }
    }
    return BorderRadius.circular(8);
  }

  BoxShadow _shadow(IconType iconType) {
    if (iconType == IconType.CIRCLE_SHAPE) {
      return const BoxShadow(
        color: Colors.grey,
        offset: Offset(1, 1),
        blurRadius: 1,
        spreadRadius: 0,
      );
    }
    return const BoxShadow(
      color: Colors.grey,
      offset: Offset(0, 0),
      blurRadius: 3,
      spreadRadius: 0,
    );
  }

  Widget _rotate({required Widget child, required RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: pi * 3 / 4,
          child: child,
        );
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: pi * 5 / 4,
          child: child,
        );
      default:
        return child;
    }
  }

  Widget _rotateRollBack(
      {required Widget child, required RotateType rotateType}) {
    switch (rotateType) {
      case RotateType.TOP_CENTER:
        return Transform.rotate(
          angle: -pi / 4,
          child: child,
        );
      case RotateType.CENTER_LEFT:
        return Transform.rotate(
          angle: -pi * 3 / 4,
          child: child,
        );
      case RotateType.CENTER_RIGHT:
        return Transform.rotate(
          angle: pi / 4,
          child: child,
        );
      case RotateType.BOTTOM_CENTER:
        return Transform.rotate(
          angle: -pi * 5 / 4,
          child: child,
        );
      default:
        return child;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (iconType == IconType.POLYGON_SHAPE) {
      return ClipPolygon(
        sides: 6,
        borderRadius: 5.0,
        // Default 0.0 degrees
        rotate: _getRotateDegrees(rotateType),
        // Default 0.0 degrees
        boxShadows: [
          PolygonBoxShadow(color: Colors.black, elevation: 1.0),
          PolygonBoxShadow(color: Colors.grey, elevation: 5.0)
        ],
        child: _makeIconContent(context, rotate: false, decoration: false),
      );
    }
    return _rotate(
      rotateType: rotateType,
      child: Container(
        decoration: BoxDecoration(
            boxShadow:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? []
                    : (!useDefault
                        ? [
                            const BoxShadow(
                                color: Colors.white24,
                                offset: Offset(-1, -1),
                                blurRadius: 2,
                                spreadRadius: 0),
                            BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(1, 1),
                                blurRadius: 1,
                                spreadRadius: 0)
                          ]
                        : [
                            _shadow(iconType),
                          ]),
            color: Theme.of(context).colorScheme.brightness == Brightness.dark
                ? const Color(0xFF4D4D4D)
                : !useDefault
                    ? const Color(0xFF243441)
                    : null,
            borderRadius: _shape(iconType, rotateType, size),
            gradient:
                Theme.of(context).colorScheme.brightness == Brightness.dark
                    ? null
                    : (linearGradient ??
                        (!useDefault
                            ? null
                            : const LinearGradient(
                                colors: [Color(0xFFEEF0F5), Color(0xFFE6E9EF)],
                                stops: [25, 75])))),
        width: size,
        height: size,
        alignment: Alignment.center,
        child: _makeIconContent(context, rotate: true, decoration: true),
      ),
    );
  }

  Widget _makeIconContent(BuildContext context,
      {bool rotate = false, bool decoration = false}) {
    return Container(
        width: size - (size * 4) / 15,
        height: size - (size * 4) / 15,
        alignment: Alignment.center,
        decoration: decoration
            ? BoxDecoration(
                gradient: linearGradientIcon ?? linearGradientIn(context),
                borderRadius:
                    _shape(iconType, rotateType, size - (size * 4) / 15),
              )
            : BoxDecoration(color: color),
        child: rotate
            ? _rotateRollBack(child: icon, rotateType: rotateType)
            : icon);
  }

  double _getRotateDegrees(RotateType rotateType) {
    if (rotateType == RotateType.TOP_LEFT ||
        rotateType == RotateType.TOP_RIGHT ||
        rotateType == RotateType.BOTTOM_LEFT ||
        rotateType == RotateType.BOTTOM_RIGHT) {
      return 30;
    }
    return 0;
  }
}
