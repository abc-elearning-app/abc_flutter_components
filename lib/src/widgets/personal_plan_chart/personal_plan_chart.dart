import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Data class
class ChartData {
  final DateTime date;
  final double value;

  ChartData(
    this.date,
    this.value,
  );
}

enum ChartType { line, expected, actual }

class PersonalPlanChart extends StatefulWidget {
  final List<ChartData> dataList;
  final List<double> expectedLineValues;

  final Color mainColor;
  final Color correctColor;
  final Color expectedColor;

  final int expectedBarValue;

  // Value range
  final double minBarValue;
  final double maxBarValue;
  final double barValueInterval;

  final double minLineValue;
  final double maxLineValue;
  final double lineValueInterval;

  final double lineWidth;
  final double lineMarkerSize;
  final double barRatio;

  final double lineSectionHeight;
  final double barSectionHeight;

  final String leftYAxisTitle;
  final String rightYAxisTitle;

  final double curveTension;
  final int displayColumns;

  final double duration;

  const PersonalPlanChart(
      {super.key,
      required this.dataList,
      required this.expectedLineValues,
      this.expectedBarValue = 50,
      this.mainColor = const Color(0xFFE3A651),
      this.correctColor = const Color(0xFF00CA9F),
      this.expectedColor = const Color(0xFFF1D6A9),
      this.minBarValue = 0,
      this.maxBarValue = 50,
      this.barValueInterval = 25,
      this.lineSectionHeight = 150,
      this.barSectionHeight = 150,
      this.minLineValue = 0,
      this.maxLineValue = 100,
      this.lineValueInterval = 50,
      this.lineWidth = 5,
      this.lineMarkerSize = 10,
      this.barRatio = 0.25,
      this.leftYAxisTitle = 'Questions Today',
      this.rightYAxisTitle = 'Passing Rate',
      this.curveTension = 1,
      this.displayColumns = 6,
      this.duration = 800});

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoomPanBehavior;

  late CategoryAxisController lineAxisController;
  late CategoryAxisController expectedAxisController;
  late CategoryAxisController actualAxisController;

  final List<double> percentValues = [];

  @override
  void initState() {
    _calculateLinePercentValues();

    _tooltip = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );

    // var time = Timer.periodic(const Duration(seconds: 2), (timer) {
    final int currentDayIndex = widget.dataList.indexWhere((data) => _compareWithCurrentTime(data.date) == 0);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      for (int i = 0; i < (currentDayIndex -(widget.dataList.length > 10 ? 5 : 2)).clamp(0, 1000); i ++) {
        _zoomPanBehavior.panToDirection('right');
      }
      // _zoomPanBehavior.panToDirection('right');
      // _zoomPanBehavior.panToDirection('right');
      // _zoomPanBehavior.panToDirection('right');
      // _zoomPanBehavior.panToDirection('right');
    });
    // });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.leftYAxisTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.rightYAxisTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Line chart
        Transform.translate(
          offset: const Offset(0, 20),
          child: SizedBox(
            height: widget.lineSectionHeight,
            child: SfCartesianChart(
              onMarkerRender: (args) => _drawLineMarker(args),
              axes: _buildPlaceHolderYAxis(),
              primaryXAxis: _buildCustomXAxis(ChartType.line),
              primaryYAxis: _buildCustomYAxis(ChartType.line),
              onZooming: (args) => _handleZooming(args, ChartType.line),
              zoomPanBehavior: _zoomPanBehavior,
              tooltipBehavior: _tooltip,
              series: [
                // Expected line
                SplineSeries<ChartData, String>(
                    dataSource: widget.dataList,
                    width: widget.lineWidth,
                    xValueMapper: (data, _) => data.date.toString(),
                    yValueMapper: (_, index) =>
                        widget.expectedLineValues[index],
                    animationDuration: widget.duration,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: widget.curveTension,
                    color: widget.expectedColor,
                    markerSettings: const MarkerSettings(isVisible: false)),

                // Actual line
                SplineSeries<ChartData, String>(
                    dataSource: widget.dataList,
                    width: widget.lineWidth,
                    xValueMapper: (ChartData data, _) => data.date.toString(),
                    yValueMapper: (ChartData data, int index) =>
                        widget.expectedLineValues[index] * percentValues[index],
                    animationDuration: widget.duration,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: widget.curveTension,
                    pointColorMapper: (ChartData data, _) =>
                        _compareWithCurrentTime(data.date) >= 0
                            ? widget.correctColor
                            : widget.mainColor,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        shape: DataMarkerType.circle,
                        borderWidth: 2,
                        borderColor: Colors.white,
                        height: widget.lineMarkerSize,
                        width: widget.lineMarkerSize,
                        color: widget.correctColor)),
              ],
            ),
          ),
        ),

        // Questions progress charts
        SizedBox(
          height: widget.barSectionHeight,
          child: Stack(
            children: [
              // Expected chart
              SfCartesianChart(
                primaryXAxis: _buildCustomXAxis(ChartType.expected),
                primaryYAxis: _buildCustomYAxis(ChartType.expected),
                onZooming: (args) => _handleZooming(args, ChartType.expected),
                zoomPanBehavior: _zoomPanBehavior,
                axes: _buildPlaceHolderYAxis(
                  isOpposed: true,
                  contain3Digits: true,
                ),
                series: [
                  StackedColumnSeries<ChartData, String>(
                    dataSource: widget.dataList,
                    width: widget.barRatio,
                    xValueMapper: (data, _) => data.date.toString(),
                    yValueMapper: (data, _) => widget.expectedBarValue,
                    animationDuration: widget.duration,
                    pointColorMapper: (data, index) =>
                        _getBarColor(index).withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                  )
                ],
              ),

              // Actual questions
              SfCartesianChart(
                  primaryXAxis: _buildCustomXAxis(ChartType.actual),
                  primaryYAxis: _buildCustomYAxis(ChartType.actual),
                  axes: _buildPlaceHolderYAxis(
                    isOpposed: true,
                    contain3Digits: true,
                  ),
                  tooltipBehavior: _tooltip,
                  zoomPanBehavior: _zoomPanBehavior,
                  onZooming: (args) => _handleZooming(args, ChartType.actual),
                  series: <CartesianSeries>[
                    StackedColumnSeries<ChartData, String>(
                      name: 'Correct Questions',
                      width: widget.barRatio,
                      dataSource: widget.dataList,
                      xValueMapper: (data, _) => data.date.toString(),
                      yValueMapper: (data, _) => data.value,
                      animationDuration: widget.duration,
                      pointColorMapper: (data, index) => _getBarColor(index),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ]),
            ],
          ),
        ),
      ],
    );
  }

  _buildCustomXAxis(ChartType type) => CategoryAxis(
        isVisible: type != ChartType.line,
        labelStyle: const TextStyle(color: Colors.transparent),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        onRendererCreated: (controller) {
          switch (type) {
            case ChartType.line:
              lineAxisController = controller;
              break;
            case ChartType.expected:
              expectedAxisController = controller;
              break;
            case ChartType.actual:
              actualAxisController = controller;
              break;
          }
        },
        initialVisibleMaximum: widget.displayColumns.toDouble(),
        initialVisibleMinimum: 0,
        initialZoomPosition: 0,
      );

  _buildCustomYAxis(ChartType type) => NumericAxis(
        opposedPosition: type == ChartType.line,
        minimum:
            type == ChartType.line ? widget.minLineValue : widget.minBarValue,
        maximum: (type == ChartType.line
                ? widget.maxLineValue
                : widget.maxBarValue) +
            2,
        interval: type == ChartType.line
            ? widget.lineValueInterval
            : widget.barValueInterval,
        axisLine: const AxisLine(color: Colors.grey),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        majorTickLines: const MajorTickLines(color: Colors.grey),
      );

  List<NumericAxis> _buildPlaceHolderYAxis({
    bool isOpposed = false,
    bool contain3Digits = false,
  }) =>
      [
        NumericAxis(
          opposedPosition: isOpposed,
          minimum: contain3Digits ? 100 : 90,
          maximum: 0,
          interval: 10,
          axisLine: AxisLine(color: Colors.grey.withOpacity(0.3)),
          labelStyle: const TextStyle(color: Colors.transparent),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          majorGridLines: const MajorGridLines(color: Colors.transparent),
        ),
      ];

  Color _getBarColor(int index) {
    if (index != widget.dataList.length - 1) return widget.mainColor;
    return widget.correctColor;
  }

  int _compareWithCurrentTime(DateTime time) {
    final currentTime = DateTime.now();

    if (time.day == currentTime.day &&
        time.month == currentTime.month &&
        time.year == currentTime.year) {
      return 0;
    }

    return time.compareTo(currentTime);
  }

  _drawLineMarker(MarkerRenderArgs args) {
    args.markerHeight = 12;
    args.markerWidth = 12;
    args.borderWidth = 2;

    final int index = args.pointIndex!;
    if (index == widget.dataList.length - 1) {
      args.color = widget.correctColor;
      args.borderColor = Colors.white;
    } else if (_compareWithCurrentTime(widget.dataList[index].date) == 0) {
      args.borderColor = widget.correctColor;
      args.color = Colors.white;
    } else {
      args.color = Colors.transparent;
      args.borderColor = Colors.transparent;
    }
  }

  _handleZooming(ZoomPanArgs args, ChartType type) {
    if (args.axis?.name == 'primaryXAxis') {
      // Storing the zoomPosition and the zoomFactor
      switch (type) {
        case ChartType.line:
          expectedAxisController.zoomPosition = args.currentZoomPosition;
          expectedAxisController.zoomFactor = args.currentZoomFactor;

          actualAxisController.zoomPosition = args.currentZoomPosition;
          actualAxisController.zoomFactor = args.currentZoomFactor;
          break;
        case ChartType.expected:
          lineAxisController.zoomPosition = args.currentZoomPosition;
          lineAxisController.zoomFactor = args.currentZoomFactor;

          actualAxisController.zoomPosition = args.currentZoomPosition;
          actualAxisController.zoomFactor = args.currentZoomFactor;
          break;
        case ChartType.actual:
          lineAxisController.zoomPosition = args.currentZoomPosition;
          lineAxisController.zoomFactor = args.currentZoomFactor;

          expectedAxisController.zoomPosition = args.currentZoomPosition;
          expectedAxisController.zoomFactor = args.currentZoomFactor;
          break;
      }
    }
  }

  _calculateLinePercentValues() {
    percentValues.clear();

    int currentDayIndex = widget.dataList
        .indexWhere((data) => _compareWithCurrentTime(data.date) == 0);

    // Previous days' percent
    for (int i = 0; i < currentDayIndex; i++) {
      var percent = widget.dataList[i].value / widget.expectedBarValue;
      percentValues.add(percent);
    }

    // Today's percent
    if (widget.dataList[currentDayIndex].value == 0) {
      // If haven't done yet -> calculate
      var predictedPercent = _calculatePercent(currentDayIndex);

      percentValues.add(predictedPercent);
    } else {
      percentValues.add(
          widget.dataList[currentDayIndex].value / widget.expectedBarValue);
    }

    for (int i = currentDayIndex + 1; i < widget.dataList.length; i++) {
      var predictedValue = _calculatePercent(i);
      percentValues.add(predictedValue);
    }
  }

  /// Formula: t(n+1) = t(n) + p * ( x(n+1) - t(n) )
  /// x is the expected value
  /// t is the actual value
  /// p is the average of previous actual values
  _calculatePercent(int index) =>
      percentValues[index - 1] +
      (percentValues.reduce((a, b) => a + b) / percentValues.length) *
          (widget.expectedBarValue -
              percentValues[index - 1] * widget.expectedBarValue) /
          widget.expectedBarValue;
}
