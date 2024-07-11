import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tuple/tuple.dart';

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
  final DateTime startDate;
  final DateTime examDate;

  final Color mainColor;
  final Color secondaryColor;
  final Color correctColor;
  final Color expectedColor;

  final int expectedBarValue;

  // Value range
  final double minBarValue;
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
    required this.startDate,
    required this.examDate,
    this.expectedBarValue = 50,
    this.mainColor = const Color(0xFFE3A651),
    this.secondaryColor = const Color(0xFF7C6F5B),
    this.correctColor = const Color(0xFF00CA9F),
    this.expectedColor = const Color(0xFFF1D6A9),
    this.minBarValue = 0,
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
    this.duration = 800,
    this.displayColumns = 6,
    required this.isDarkMode,
  });

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  // late TooltipBehavior _tooltip;

  // Input data list
  List<ChartData> dataList = [];
  List<double> expectedLineValues = [];
  final List<double> percentValues = [];

  // Bar's average value
  List<double> averageValues = [];

  // For displaying tooltip
  List<Tuple2<DateTime, DateTime>> dateGroups = [];

  // Amount of days displayed in a column
  List<int> daysInGroup = [];

  // Index of the column that contains the current day
  int currentColumnIndex = 0;

  int get daysTillExam =>
      widget.examDate.difference(widget.startDate).inDays + 2;

  bool get isLessColumnThanDefault => daysTillExam < widget.displayColumns;

  int get columns =>
      isLessColumnThanDefault ? daysTillExam : widget.displayColumns;

  @override
  void initState() {
    // Initial calculations
    _calculateAverageValues();
    _createDateGroups();
    _calculateExpectedLineValues();
    _calculateLinePercentValues();
    super.initState();
  }

  /// Initial calculations
  _calculateAverageValues() {
    // If the days from start to exam date is less than default display columns
    if (isLessColumnThanDefault) {
      averageValues.addAll(widget.valueList.map((e) => e.toDouble()));
      final remainDays = daysTillExam - averageValues.length;
      averageValues.addAll(List.generate(remainDays, (_) => 0));

      daysInGroup = List.generate(
        columns,
        (_) => 1,
      );

      return;
    }

    // Calculate days in a group (varies among columns)
    // Calculate days till exam date and divide into columns
    final minDaysInGroup = daysTillExam ~/ widget.displayColumns;

    // List to know each column has how many days
    daysInGroup = List.generate(
      columns,
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
    int currentDayIndex = DateTime.now().difference(widget.startDate).inDays;

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

  _createDateGroups() {
    DateTime tmpDate = widget.startDate;
    for (int i = 0; i < columns; i++) {
      dateGroups.add(Tuple2(
        tmpDate,
        tmpDate.add(Duration(days: daysInGroup[i] - 1)),
      ));
      tmpDate = tmpDate.add(Duration(days: daysInGroup[i]));
    }
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
      if (i == 0 && averageValues[i] == 0) {
        percentValues.add(0.2);
      } else {
        final percent = averageValues[i] / widget.expectedBarValue;
        percentValues.add(percent);
      }
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
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
              Text(
                widget.rightYAxisTitle,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.isDarkMode ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),

        // Line chart
        SizedBox(
          height: widget.lineSectionHeight,
          child: SfCartesianChart(
            onMarkerRender: (args) => _drawLineMarker(args),
            axes: _buildPlaceHolderYAxis(
                contain3Digits: widget.expectedBarValue > 90),
            primaryXAxis: _buildCustomXAxis(ChartType.line),
            primaryYAxis: _buildCustomYAxis(ChartType.line),
            tooltipBehavior: _buildTooltip(ChartType.line, 'Pass percent'),
            series: _personalPlanLineSeries(),
          ),
        ),

        // Questions progress bar charts
        Transform.translate(
          offset: const Offset(0, -20),
          child: SizedBox(
            height: widget.barSectionHeight,
            child: Stack(children: [
              _barChart('Expected Questions', ChartType.expected),
              _barChart('Actual Questions', ChartType.actual),
            ]),
          ),
        ),
      ],
    );
  }

  _personalPlanLineSeries() => [
        // Expected line
        SplineSeries<double, String>(
            name: 'Expected progress',
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
            name: 'Current progress',
            dataSource: percentValues,
            width: widget.lineWidth,
            xValueMapper: (_, index) => index.toString(),
            yValueMapper: (value, index) => expectedLineValues[index] * value,
            animationDuration: widget.duration,
            splineType: SplineType.cardinal,
            cardinalSplineTension: widget.curveTension,
            pointColorMapper: (_, index) => index >= currentColumnIndex
                ? widget.correctColor
                : widget.mainColor,
            markerSettings: MarkerSettings(
                isVisible: true,
                borderWidth: 2,
                shape: DataMarkerType.circle,
                borderColor: Colors.white,
                height: widget.lineMarkerSize,
                width: widget.lineMarkerSize,
                color: widget.correctColor)),
      ];

  Widget _barChart(String title, ChartType chartType) => SfCartesianChart(
          primaryXAxis: _buildCustomXAxis(ChartType.actual),
          primaryYAxis: _buildCustomYAxis(ChartType.actual),
          axes: _buildPlaceHolderYAxis(
            isOpposed: true,
            contain3Digits: true,
          ),
          tooltipBehavior: _buildTooltip(ChartType.actual, 'Questions'),
          series: <CartesianSeries>[
            StackedColumnSeries<double, String>(
              name: title,
              dataSource: averageValues,
              width: widget.barRatio,
              xValueMapper: (_, index) => index.toString(),
              yValueMapper: (value, _) => chartType == ChartType.expected
                  ? widget.expectedBarValue
                  : value,
              animationDuration: widget.duration,
              pointColorMapper: (data, index) => _getBarColor(index)
                  .withOpacity(chartType == ChartType.expected ? 0.2 : 1),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
            ),
          ]);

  /// Chart drawing utils
  _buildTooltip(ChartType chartType, String title) => TooltipBehavior(
      enable: true,
      builder: (_, __, ___, pointIndex, ____) {
        final startDate = dateGroups[pointIndex].item1;
        final endDate = dateGroups[pointIndex].item2;
        final startDateString = '${startDate.day}/${startDate.month}';
        final endDateString = '${endDate.day}/${endDate.month}';

        double value = 0;
        if (!(widget.valueList.length == 1 &&
            widget.valueList[0] == 0 &&
            pointIndex == 0)) {
          value = chartType == ChartType.line
              ? (percentValues[pointIndex] * 100)
              : ((averageValues[pointIndex] / widget.expectedBarValue) * 100);
        }

        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.isDarkMode ? Colors.black : Colors.grey,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  )),
              const SizedBox(height: 10),
              Text(
                '$startDateString - $endDateString',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(width: 80, child: Divider()),
              Text(
                '${value.toInt()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        );
      });

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
                : (widget.expectedBarValue ~/ 10 * 10 + 1)) +
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
    if (index != columns - 1) return widget.mainColor;
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
}
