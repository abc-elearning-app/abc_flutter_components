import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double expected;
  final double actual;
  final double lineValue;
  final Color barColor;
  final Color lineColor;

  ChartData(this.category,
      this.expected,
      this.actual,
      this.lineValue,
      this.barColor,
      this.lineColor,);
}

class PersonalPlanChart extends StatefulWidget {
  final Color mainColor;
  final Color correctColor;

  final double minColumnValue;
  final double maxColumnValue;
  final double columnInterval;

  const PersonalPlanChart({super.key,
    this.mainColor = const Color(0xFFE3A651),
    this.correctColor = const Color(0xFF00CA9F),
    this.minColumnValue = 0,
    this.maxColumnValue = 50,
    this.columnInterval = 10});

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      ChartData('10/3', 30, 12, 50, widget.mainColor, widget.mainColor),
      ChartData('11/3', 30, 25, 52, widget.mainColor, widget.mainColor),
      ChartData('12/3', 30, 10, 55, widget.mainColor, widget.mainColor),
      ChartData('13/3', 30, 0, 60, widget.mainColor, widget.correctColor),
      ChartData('14/3', 30, 0, 65, widget.mainColor, widget.correctColor),
      ChartData('15/3', 30, 20, 70, widget.correctColor, widget.correctColor),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      onMarkerRender: (args) {
        final value = data[args.pointIndex!];

        args.markerHeight = 12;
        args.markerWidth = 12;
        args.borderWidth = 2;

        if (value.lineValue == 60) {
          args.borderColor = widget.correctColor;
          args.color = Colors.white;
        } else if (value.lineValue == 70) {
          args.color = widget.correctColor;
          args.borderColor = Colors.white;
        } else {
          args.color = Colors.transparent;
          args.borderColor = Colors.transparent;
        }
      },
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        labelStyle: TextStyle(color: Colors.transparent),
        majorTickLines: MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(color: Colors.transparent),
      ),
      primaryYAxis: NumericAxis(
        minimum: widget.minColumnValue,
        maximum: widget.maxColumnValue,
        interval: widget.columnInterval,
        majorGridLines: const MajorGridLines(color: Colors.transparent),
      ),
      axes: const [
        NumericAxis(
          name: 'line',
          plotOffset: 50,
          opposedPosition: true,
          minimum: 0,
          maximum: 100,
          interval: 50,
          majorGridLines: MajorGridLines(color: Colors.transparent),
        ),
      ],
      tooltipBehavior: _tooltip,
      series: <CartesianSeries>[
        StackedColumnSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.actual,
          name: 'Expected',
          pointColorMapper: (ChartData data, _) => data.barColor,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          width: 0.25,
        ),
        StackedColumnSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.expected - data.actual,
          name: 'Actual',
          pointColorMapper: (ChartData data, _) => data.barColor.withOpacity(0.1),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            topLeft: Radius.circular(50),
          ),
          width: 0.25,
        ),
        SplineSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.lineValue,
          yAxisName: 'line',
          width: 5,
          pointColorMapper: (ChartData data, _) => data.lineColor,
          markerSettings: MarkerSettings(
              isVisible: true,
              shape: DataMarkerType.circle,
              borderWidth: 2,
              borderColor: Colors.white,
              height: 10,
              width: 10,
              color: widget.correctColor),
        ),
        SplineSeries<ChartData, String>(
          dataSource: data,
          xValueMapper: (ChartData data, _) => data.category,
          yValueMapper: (ChartData data, _) => data.lineValue + 15,
          yAxisName: 'line',
          width: 6,
          color: const Color(0xFFF1D6A9),
          markerSettings: const MarkerSettings(isVisible: false),
        ),
      ],
    );
  }
}
