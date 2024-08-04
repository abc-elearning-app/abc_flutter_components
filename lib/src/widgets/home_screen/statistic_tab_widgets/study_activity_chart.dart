import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';

enum StudyActivityChartType { line, bar }

class StudyActivityChart extends StatefulWidget {
  final int option;
  final List<Tuple2<int, double>> dataList;
  final int displayDays;

  final bool isDarkMode;
  final Color lineColor;
  final Color barColor;

  final String leftYAxisTitle;
  final String rightYAxisTitle;

  final double lineSectionHeight;
  final double barSectionHeight;

  final double minBarValue;
  final double maxBarValue;
  final double barValueInterval;

  final double minLineValue;
  final double maxLineValue;
  final double lineValueInterval;

  final double lineWidth;
  final double lineMarkerSize;
  final double barRatio;

  final double curveTension;
  final double duration;

  const StudyActivityChart({
    super.key,
    required this.dataList,
    required this.displayDays,
    required this.isDarkMode,
    this.lineColor = const Color(0xFF00CA9F),
    this.barColor = const Color(0xFFE3A651),
    this.leftYAxisTitle = 'Learnt Questions',
    this.rightYAxisTitle = 'Study Time',
    this.minBarValue = 0,
    this.maxBarValue = 50,
    this.barValueInterval = 25,
    this.lineSectionHeight = 120,
    this.barSectionHeight = 210,
    this.minLineValue = 0,
    this.maxLineValue = 12,
    this.lineValueInterval = 4,
    this.lineWidth = 5,
    this.lineMarkerSize = 10,
    this.barRatio = 0.35,
    this.curveTension = 1,
    this.duration = 800,
    required this.option,
  });

  @override
  State<StudyActivityChart> createState() => _StudyActivityChartState();
}

class _StudyActivityChartState extends State<StudyActivityChart> {
  int get columns => widget.displayDays == 7 ? 7 : 6;

  List<int> barValues = [];
  List<double> lineValues = [];

  @override
  void initState() {
    _initCalculation();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StudyActivityChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.option != widget.option) {
      _initCalculation();
    }
  }

  _initCalculation() {
    final learntQuestionList =
        widget.dataList.map((tuple) => tuple.item1).toList();
    final studyTimeList = widget.dataList.map((tuple) => tuple.item2).toList();

    barValues.clear();
    lineValues.clear();
    switch (widget.displayDays) {
      case 7:
        {
          barValues = learntQuestionList;
          lineValues = studyTimeList;
          break;
        }
      default:
        {
          int startIndex = 0;
          int step = widget.displayDays == 30 ? 5 : 15;
          while (startIndex < widget.dataList.length) {
            barValues.add((learntQuestionList
                        .sublist(startIndex, startIndex + step)
                        .reduce((a, b) => a + b) /
                    step)
                .ceil());

            lineValues.add((studyTimeList
                    .sublist(startIndex, startIndex + step)
                    .reduce((a, b) => a + b) /
                step));

            startIndex += step;
          }
        }
    }

    // Remove empty columns
    barValues = barValues.where((value) => value != 0).toList();
    lineValues = lineValues.where((value) => value != 0).toList();

    // Add place holder 0 to the end of list
    if (barValues.length < columns) {
      barValues.addAll(List.generate(columns - barValues.length, (_) => 0));
      lineValues.addAll(List.generate(columns - lineValues.length, (_) => 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),

        // Line chart
        Column(
          children: [
            SizedBox(
              height: widget.lineSectionHeight,
              child: SfCartesianChart(
                onMarkerRender: (args) => _drawLineMarker(args),
                axes: _buildPlaceHolderYAxis(),
                primaryXAxis: _buildCustomXAxis(StudyActivityChartType.line),
                primaryYAxis: _buildCustomYAxis(StudyActivityChartType.line),
                tooltipBehavior: _buildTooltip(StudyActivityChartType.line),
                series: [
                  SplineSeries<double, String>(
                    name: 'Study time',
                    dataSource: lineValues,
                    width: widget.lineWidth,
                    xValueMapper: (_, index) => index.toString(),
                    yValueMapper: (value, index) => value,
                    animationDuration: widget.duration,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: widget.curveTension,
                    markerSettings: MarkerSettings(
                        isVisible: true,
                        borderWidth: 2,
                        shape: DataMarkerType.circle,
                        borderColor: Colors.white,
                        height: widget.lineMarkerSize,
                        width: widget.lineMarkerSize,
                        color: widget.lineColor),
                    pointColorMapper: (_, index) =>
                        index < widget.dataList.length - 1
                            ? widget.lineColor
                            : Colors.transparent,
                  ),
                ],
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -20),
              child: SizedBox(
                height: widget.barSectionHeight,
                child: SfCartesianChart(
                  axes: _buildPlaceHolderYAxis(isOpposed: true),
                  primaryXAxis: _buildCustomXAxis(StudyActivityChartType.bar),
                  primaryYAxis: _buildCustomYAxis(StudyActivityChartType.bar),
                  tooltipBehavior: _buildTooltip(StudyActivityChartType.bar),
                  series: [
                    StackedColumnSeries<int, String>(
                      name: 'Learnt Questions',
                      dataSource: barValues,
                      width: widget.barRatio,
                      xValueMapper: (_, index) => index.toString(),
                      yValueMapper: (value, _) => value,
                      animationDuration: widget.duration,
                      pointColorMapper: (data, index) => _getBarColor(index),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitle() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.leftYAxisTitle,
              style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode ? Colors.white : Colors.black),
            ),
            Text(
              widget.rightYAxisTitle,
              style: TextStyle(
                  fontSize: 14,
                  color: widget.isDarkMode ? Colors.white : Colors.black),
            ),
          ],
        ),
      );

  _getBarColor(index) {
    final lastIndex = lineValues.lastIndexWhere((value) => value != 0);
    return index == lastIndex ? widget.lineColor : widget.barColor;
  }

  _drawLineMarker(MarkerRenderArgs args) {
    args.markerHeight = 12;
    args.markerWidth = 12;
    args.borderWidth = 2;

    final lastIndex = lineValues.lastIndexWhere((value) => value != 0);

    final int index = args.pointIndex!;
    if (index == 0 || index == lastIndex) {
      args.color = widget.lineColor;
      args.borderColor = Colors.grey.shade200;
    } else {
      args.color = Colors.transparent;
      args.borderColor = Colors.transparent;
    }
  }

  List<NumericAxis> _buildPlaceHolderYAxis({
    bool isOpposed = false,
    bool contain3Digits = false,
  }) =>
      [
        NumericAxis(
          opposedPosition: isOpposed,
          minimum: contain3Digits ? 100 : 50,
          maximum: 0,
          interval: 50,
          axisLine: AxisLine(color: Colors.grey.withOpacity(0.3)),
          labelStyle: const TextStyle(color: Colors.transparent),
          majorTickLines: const MajorTickLines(color: Colors.transparent),
          majorGridLines: const MajorGridLines(color: Colors.transparent),
        ),
      ];

  _buildCustomXAxis(StudyActivityChartType type) => CategoryAxis(
        isVisible: type != StudyActivityChartType.line,
        labelStyle:
            TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
      );

  _buildCustomYAxis(StudyActivityChartType type) => NumericAxis(
        plotOffset: type == StudyActivityChartType.line ? 10 : 0,
        opposedPosition: type == StudyActivityChartType.line,
        minimum: type == StudyActivityChartType.line
            ? widget.minLineValue
            : widget.minBarValue,
        maximum: (type == StudyActivityChartType.line
                ? widget.maxLineValue
                : widget.maxBarValue) +
            (type != StudyActivityChartType.line ? 5 : 0),
        interval: type == StudyActivityChartType.line
            ? widget.lineValueInterval
            : widget.barValueInterval,
        axisLine: const AxisLine(color: Colors.grey),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        majorTickLines: const MajorTickLines(color: Colors.grey),
      );

  _buildTooltip(StudyActivityChartType chartType) => TooltipBehavior(
      enable: true,
      builder: (_, __, ___, pointIndex, ____) {
        // final startDate = dateGroups[pointIndex].item1;
        // final endDate = dateGroups[pointIndex].item2;
        // final startDateString = '${startDate.day}/${startDate.month}';
        // final endDateString = '${endDate.day}/${endDate.month}';
        //
        // final value = chartType == ChartType.line
        //     ? (percentValues[pointIndex] * 100)
        //     : ((averageValues[pointIndex] / widget.expectedBarValue) * 100);

        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '',
                // '$startDateString - $endDateString',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              SizedBox(width: 80, child: Divider()),
              Text(
                '',
                // '${value.toInt()}%',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      });
}
