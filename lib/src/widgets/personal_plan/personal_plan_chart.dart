import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// Data class
class ChartData {
  final DateTime date;
  final int value;

  ChartData(
    this.date,
    this.value,
  );
}

enum ChartType { line, expected, actual }

class PersonalPlanChart extends StatefulWidget {
  final List<int> valueList;
  final DateTime startTime;
  final DateTime examDate;

  final Color mainColor;
  final Color secondaryColor;
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
  final bool isDarkMode;

  const PersonalPlanChart({
    super.key,

    /// Important: length of valueList must equal
    /// the difference (in days) between startDate and currentDate
    /// Eg: startDate is 20/5, today is 25/5 -> valueList length should be 5
    required this.valueList,
    required this.startTime,
    required this.examDate,
    this.expectedBarValue = 50,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
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
    this.duration = 800,
    required this.isDarkMode,
  });

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  late TooltipBehavior _tooltip;

  List<ChartData> dataList = [];
  List<double> expectedLineValues = [];
  final List<double> percentValues = [];

  List<double> averageValues = [];

  int currentColumnIndex = 0;

  int get daysTillExam =>
      widget.examDate.difference(widget.startTime).inDays + 1;

  bool get isLessThanDefault => daysTillExam < widget.displayColumns;

  int get columns => isLessThanDefault ? daysTillExam : widget.displayColumns;

  @override
  void initState() {
    _tooltip = TooltipBehavior(enable: true);

    // Initial calculations
    _calculateAverageValues();
    _calculateExpectedLineValues();
    _calculateLinePercentValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Axis title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.leftYAxisTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                widget.rightYAxisTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode ? Colors.white : Colors.black),
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
              tooltipBehavior: _tooltip,
              series: [
                // Expected line
                SplineSeries<double, String>(
                    name: 'Expected',
                    dataSource: expectedLineValues,
                    width: widget.lineWidth,
                    xValueMapper: (_, index) => index.toString(),
                    yValueMapper: (value, _) => value,
                    animationDuration: widget.duration,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: widget.curveTension,
                    color: widget.expectedColor,
                    markerSettings: const MarkerSettings(isVisible: false)),

                // Actual line
                SplineSeries<double, String>(
                    name: 'Progress',
                    dataSource: percentValues,
                    width: widget.lineWidth,
                    xValueMapper: (_, index) => index.toString(),
                    yValueMapper: (value, index) =>
                        expectedLineValues[index] * value,
                    animationDuration: widget.duration,
                    splineType: SplineType.cardinal,
                    cardinalSplineTension: widget.curveTension,
                    pointColorMapper: (_, index) => index >= currentColumnIndex
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
          child: SfCartesianChart(
              primaryXAxis: _buildCustomXAxis(ChartType.actual),
              primaryYAxis: _buildCustomYAxis(ChartType.actual),
              axes: _buildPlaceHolderYAxis(
                isOpposed: true,
                contain3Digits: true,
              ),
              tooltipBehavior: _tooltip,
              series: <CartesianSeries>[
                StackedColumnSeries<double, String>(
                  name: 'Correct Questions',
                  dataSource: averageValues,
                  width: widget.barRatio,
                  xValueMapper: (_, index) => index.toString(),
                  yValueMapper: (value, _) => value,
                  animationDuration: widget.duration,
                  pointColorMapper: (data, index) => _getBarColor(index),
                ),
                StackedColumnSeries<double, String>(
                  name: 'Expected Questions',
                  width: widget.barRatio,
                  dataSource: averageValues,
                  xValueMapper: (_, index) => index.toString(),
                  yValueMapper: (value, _) => widget.expectedBarValue - value,
                  animationDuration: widget.duration,
                  pointColorMapper: (data, index) =>
                      _getBarColor(index).withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
              ]),
        ),
      ],
    );
  }

  /// Chart drawing utils

  _buildCustomXAxis(ChartType type) => CategoryAxis(
        isVisible: type != ChartType.line,
        labelStyle: const TextStyle(color: Colors.transparent),
        majorTickLines: const MajorTickLines(width: 0),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
      );

  _buildCustomYAxis(ChartType type) => NumericAxis(
        plotOffset: type == ChartType.line ? 10 : 0,
        opposedPosition: type == ChartType.line,
        minimum:
            type == ChartType.line ? widget.minLineValue : widget.minBarValue,
        maximum: (type == ChartType.line
                ? widget.maxLineValue
                : widget.maxBarValue) +
            (type != ChartType.line ? 5 : 0),
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
    if (index != widget.displayColumns - 1) return widget.mainColor;
    return widget.correctColor;
  }

  _drawLineMarker(MarkerRenderArgs args) {
    args.markerHeight = 12;
    args.markerWidth = 12;
    args.borderWidth = 2;

    final int index = args.pointIndex!;
    if (index == columns - 1) {
      args.color = widget.correctColor;
      args.borderColor = Colors.white;
    } else if (index == currentColumnIndex) {
      args.borderColor = widget.correctColor;
      args.color = Colors.white;
    } else {
      args.color = Colors.transparent;
      args.borderColor = Colors.transparent;
    }
  }

  /// Initial calculations
  _calculateAverageValues() {
    // If the days from start to exam date is less than default display columns
    if (isLessThanDefault) {
      averageValues.addAll(widget.valueList.map((e) => e.toDouble()));
      final remainDays = daysTillExam - averageValues.length;
      averageValues.addAll(List.generate(remainDays, (_) => 0));

      return;
    }

    // Calculate days in a group (varies among columns)
    // Calculate days till exam date and divide into columns
    final minDaysInGroup = daysTillExam ~/ widget.displayColumns;

    // List to know each column has how many days
    List<int> daysInGroup = List.generate(
      widget.displayColumns,
      (_) => minDaysInGroup,
    );

    // For each remaining day, add to a column from right to left
    int remainDays = daysTillExam % widget.displayColumns;
    int index = daysInGroup.length - 1;
    while (remainDays > 0) {
      daysInGroup[index]++;
      remainDays--;
      index--;
    }

    // Index of current day from start time
    int currentDayIndex = DateTime.now().difference(widget.startTime).inDays;

    // Index of the column that contains current day
    currentColumnIndex = 0;
    int dayPast = 0;
    for (int i = 0; i < daysInGroup.length; i++) {
      dayPast += daysInGroup[i];
      if (dayPast >= currentDayIndex) {
        currentColumnIndex = i;
        break;
      }
    }

    // Calculate average values of each group till the current group (exclude the current group)
    averageValues = [];
    int startGroupIndex = 0;
    for (int i = 0; i < currentColumnIndex; i++) {
      int sum = widget.valueList
          .sublist(startGroupIndex, startGroupIndex + daysInGroup[i])
          .reduce((a, b) => a + b);
      averageValues.add(sum / daysInGroup[i]);

      startGroupIndex += daysInGroup[i];
    }

    // Calculate current day group's average
    int sum = widget.valueList
        .sublist(startGroupIndex, widget.valueList.length)
        .reduce((a, b) => a + b);
    averageValues.add(sum / (widget.valueList.length - startGroupIndex));

    // The rest are all 0
    int remainColumns = widget.displayColumns - averageValues.length;
    averageValues.addAll(List.generate(remainColumns, (_) => 0));
  }

  _calculateExpectedLineValues() {
    // Evenly divide expected value range from 10 to 100%
    double gap = (100 - 10) / (columns - 1);
    for (int i = 0; i < columns; i++) {
      expectedLineValues.add(10 + i * gap);
    }
  }

  _calculateLinePercentValues() {
    // Previous days' percent
    for (int i = 0; i <= currentColumnIndex; i++) {
      final percent = averageValues[i] / widget.expectedBarValue;
      percentValues.add(percent);
    }

    // Calculate future prediction
    for (int i = currentColumnIndex + 1; i < columns; i++) {
      percentValues.add(_calculatePrediction(i));
    }
  }

  /// Formula: t(n+1) = t(n) + p * ( x(n+1) - t(n) )
  /// x is the expected value
  /// t is the actual value
  /// p is the average of previous actual values
  _calculatePrediction(int index) =>
      percentValues[index - 1] +
      (percentValues.reduce((a, b) => a + b) / percentValues.length) *
          (widget.expectedBarValue * (1 - percentValues[index - 1])) /
          widget.expectedBarValue;
}
