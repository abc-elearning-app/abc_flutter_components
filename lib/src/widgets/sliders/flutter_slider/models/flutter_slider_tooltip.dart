import 'package:flutter/widgets.dart';

import '../../../../../flutter_abc_jsc_components.dart';

class FlutterSliderTooltip {
  Widget Function(dynamic value)? custom;
  String Function(String value)? format;
  TextStyle? textStyle;
  FlutterSliderTooltipBox? boxStyle;
  Widget? leftPrefix;
  Widget? leftSuffix;
  Widget? rightPrefix;
  Widget? rightSuffix;
  bool? alwaysShowTooltip;
  bool? disabled;
  bool? disableAnimation;
  FlutterSliderTooltipDirection? direction;
  FlutterSliderTooltipPositionOffset? positionOffset;

  FlutterSliderTooltip({
    this.custom,
    this.format,
    this.textStyle,
    this.boxStyle,
    this.leftPrefix,
    this.leftSuffix,
    this.rightPrefix,
    this.rightSuffix,
    this.alwaysShowTooltip,
    this.disableAnimation,
    this.disabled,
    this.direction,
    this.positionOffset,
  });

  @override
  String toString() {
    return '$textStyle-$boxStyle-$leftPrefix-$leftSuffix-$rightPrefix-$rightSuffix-$alwaysShowTooltip-$disabled-$disableAnimation-$direction-$positionOffset';
  }
}
