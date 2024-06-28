import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' show pi, cos, sin, max;

class SpiderChart extends StatelessWidget {
  final bool outerGraph;
  final List<double> data;
  final List<Color> colors;
  final MaterialColor? colorSwatch;
  final List<String> labels;
  final double? maxValue;
  final int decimalPrecision;
  final Size size;
  final double fallbackHeight;
  final double fallbackWidth;

  SpiderChart({
    super.key,
    required this.data,
    this.outerGraph = false,
    this.colors = const [],
    this.maxValue,
    this.labels = const [],
    this.size = Size.infinite,
    this.decimalPrecision = 0,
    this.fallbackHeight = 200,
    this.fallbackWidth = 200,
    this.colorSwatch,
  })  : assert(labels.isNotEmpty ? data.length == labels.length : true,
            'Length of data and labels lists must be equal'),
        assert(colors.isNotEmpty ? colors.length == data.length : true,
            "Custom colors length and data length must be equal"),
        assert(colorSwatch != null ? data.length < 10 : true,
            "For large data sets (>10 data points), please define custom colors using the [colors] parameter");

  @override
  Widget build(BuildContext context) {
    final dataPointColors = colors.isNotEmpty
        ? colors
        : _computeStepColors(colorSwatch ?? Colors.blue, data.length);

    final calculatedMax = maxValue ?? data.reduce(max);

    return Stack(children: [
      LimitedBox(
        maxWidth: fallbackWidth,
        maxHeight: fallbackHeight,
        child: CustomPaint(
          size: size,
          painter: SpiderChartPainter(
            outerGraph,
            data,
            calculatedMax,
            dataPointColors,
            labels,
            decimalPrecision,
          ),
        ),
      ),
      Positioned.fill(
          child: Center(
              child: Container(
                width: 30,
        height: 15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey.withOpacity(0.2)
        ),
        child: const Center(child: Text('0', style: TextStyle(fontSize: 8),)),
      ))),
      Align(
        alignment: Alignment.center,
        child: Transform.translate(
          offset: const Offset(0, 30),
          child: Container(
            width: 30,
            height: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.2)
            ),
            child: const Center(child: Text('60', style: TextStyle(fontSize: 8.5),)),
          ),
        ),
      ),
      Align(
        alignment: Alignment.topCenter,
        child: Transform.translate(
          offset: const Offset(0, -8),
          child: Container(
            width: 30,
            height: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.withOpacity(0.2)
            ),
            child: const Center(child: Text('100', style: TextStyle(fontSize: 8.5),)),
          ),
        ),
      )
    ]);
  }

  List<Color> _computeStepColors(MaterialColor swatch, int steps) {
    final swatchColors = <Color>[];
    for (int i = 0; i < steps; i++) {
      final ratio = i / steps;
      final stepColor = Color.lerp(swatch[300]!, swatch[900]!, ratio)!;
      swatchColors.add(stepColor);
    }
    return swatchColors;
  }
}

class SpiderChartPainter extends CustomPainter {
  final bool outerGraph;
  final List<double> data;
  final double maxNumber;
  final List<Color> colors;
  final List<String> labels;
  final int decimalPrecision;

  final Paint spokes = Paint()..color = Colors.black;

  final Paint fill = Paint()
    ..color = const Color.fromARGB(15, 50, 50, 50)
    ..style = PaintingStyle.fill;

  final Paint stroke = Paint()
    ..color = const Color.fromARGB(255, 50, 50, 50)
    ..style = PaintingStyle.stroke;

  SpiderChartPainter(
    this.outerGraph,
    this.data,
    this.maxNumber,
    this.colors,
    this.labels,
    this.decimalPrecision,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final angle = (2 * pi) / data.length;
    final dataPoints = List.generate(data.length, (i) {
      final scaledRadius = (data[i] / maxNumber) * center.dy;
      final x = scaledRadius * cos(angle * i - pi / 2);
      final y = scaledRadius * sin(angle * i - pi / 2);
      return Offset(x, y) + center;
    });

    final outerPoints = List.generate(data.length, (i) {
      final x = center.dy * cos(angle * i - pi / 2);
      final y = center.dy * sin(angle * i - pi / 2);
      return Offset(x, y) + center;
    });

    if (labels.isNotEmpty) {
      paintLabels(canvas, center, outerPoints);
    }

    paintSpiderWeb(canvas, center, outerPoints);
    paintDataLines(canvas, dataPoints);
    paintDataPoints(canvas, dataPoints);
  }

  void paintDataLines(Canvas canvas, List<Offset> points) {
    final path = Path()..addPolygon(points, true);
    const opacity = 0.3;

    // Define the gradient colors
    final gradient = LinearGradient(
      colors: [
        const Color(0xFFAFE2FF).withOpacity(opacity),
        const Color(0xFF9ABCFF).withOpacity(opacity),
        const Color(0xFF4995EE).withOpacity(opacity)
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Create a Paint object with a gradient shader
    final gradientPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(path.getBounds());

    // Draw the path with the gradient color
    canvas.drawPath(path, gradientPaint);

    // Draw the stroke around the filled area
    canvas.drawPath(
      path,
      stroke
        ..strokeWidth = 1
        ..color = Colors.blue,
    );
  }

  void paintDataPoints(Canvas canvas, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], 2.5, Paint()..color = Colors.black);
      canvas.drawCircle(points[i], 2.2, Paint()..color = colors[i]);
    }
  }

  void paintSpiderWeb(Canvas canvas, Offset center, List<Offset> points) {
    for (var i = 0; i < points.length; i++) {
      canvas.drawLine(center, points[i], spokes);
    }

    for (int j = 0; j < 5; j++) {
      for (var i = 0; i < points.length; i++) {
        final dotPosition1 = center + (points[i] - center) * ((j + 1) / 5);
        final dotPosition2 =
            center + (points[(i + 1) % points.length] - center) * ((j + 1) / 5);
        canvas.drawLine(dotPosition1, dotPosition2, spokes);
      }
    }

    for (var i = 1; i < points.length; i++) {
      final dotPosition = points[i];
      canvas.drawCircle(dotPosition, 3, spokes);
    }

    canvas.drawPoints(PointMode.polygon, [...points, points[0]], spokes);
    canvas.drawCircle(center, 1, spokes);
  }

  void paintLabels(Canvas canvas, Offset center, List<Offset> points) {
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.w500,
    );

    textPainter.text = TextSpan(text: labels[0], style: textStyle);
    textPainter.layout();

    var labelOffsetX = -(textPainter.size.width / 2);
    var labelOffsetY = -30.0; // Adjust vertical offset to make text closer to vertices

    final firstLabelPosition = points[0] + Offset(labelOffsetX, labelOffsetY);
    textPainter.paint(canvas, firstLabelPosition);

    for (var i = 1; i < points.length; i++) {
      textPainter.text = TextSpan(text: labels[i], style: textStyle);
      textPainter.layout();

      if (points[i].dx < center.dx) {
        labelOffsetX = -(textPainter.size.width + 10.0);
      } else if (points[i].dx > center.dx) {
        labelOffsetX = 10.0;
      } else {
        labelOffsetX = -(textPainter.size.width / 2);
      }

      if (points[i].dy < center.dy) {
        labelOffsetY = -15; // Adjust vertical offset for labels above the center
      } else {
        labelOffsetY = 5; // Adjust vertical offset for labels below the center
      }

      final labelPosition = points[i] + Offset(labelOffsetX, labelOffsetY);
      textPainter.paint(canvas, labelPosition);
    }
  }


  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
