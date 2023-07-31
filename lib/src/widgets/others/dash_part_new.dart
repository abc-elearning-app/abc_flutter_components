import 'dart:ui';

import 'package:path_drawing/path_drawing.dart';

/// Creates a new path that is drawn from the segments of `source`.
///
/// Dash intervals are controled by the `dashArray` - see [CircularIntervalList]
/// for examples.
///
/// `dashOffset` specifies an initial starting point for the dashing.
///
/// Passing in a null `source` will result in a null result.  Passing a `source`
/// that is an empty path will return an empty path.
Path? dashPathWidthLimit(
    Path? source, {
      required CircularIntervalList<double> dashArray,
      DashOffset? dashOffset,
      int? limit,
    }) {
  if (source == null) {
    return null;
  }
  limit = limit ?? 0;
  dashOffset = dashOffset ?? const DashOffset.absolute(0.0);
  // TODO: Is there some way to determine how much of a path would be visible today?
  final Path dest = Path();
  for (final PathMetric metric in source.computeMetrics()) {
    double distance = dashOffset._calculate(metric.length);
    bool draw = true;
    int index = 0;
    while (distance < metric.length) {
      final double len = dashArray.next;
      if (draw || limit > 0 && index < limit || limit < 0 && limit > -1*index) {
        dest.addPath(metric.extractPath(distance, distance + len), Offset.zero);
      }
      distance += len;
      draw = !draw;
      index++;
    }
  }

  return dest;
}

enum _DashOffsetType { absolute, percentage }

/// Specifies the starting position of a dash array on a path, either as a
/// percentage or absolute value.
///
/// The internal value will be guaranteed to not be null.
class DashOffset {
  /// Create a DashOffset that will be measured as a percentage of the length
  /// of the segment being dashed.
  ///
  /// `percentage` will be clamped between 0.0 and 1.0; null will be converted
  /// to 0.0.
  DashOffset.percentage(double? percentage)
      : _rawVal = percentage?.clamp(0.0, 1.0) ?? 0.0,
        _dashOffsetType = _DashOffsetType.percentage;

  /// Create a DashOffset that will be measured in terms of absolute pixels
  /// along the length of a [Path] segment.
  ///
  /// `start` will be coerced to 0.0 if null.
  const DashOffset.absolute(double? start)
      : _rawVal = start ?? 0.0,
        _dashOffsetType = _DashOffsetType.absolute;

  final double _rawVal;
  final _DashOffsetType _dashOffsetType;

  double _calculate(double length) {
    return _dashOffsetType == _DashOffsetType.absolute
        ? _rawVal
        : length * _rawVal;
  }
}
