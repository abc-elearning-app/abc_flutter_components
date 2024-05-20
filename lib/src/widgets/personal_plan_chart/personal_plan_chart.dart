import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.category, this.expected, this.actual, this.lineValue);

  final String category;
  final double expected;
  final double actual;
  final double lineValue; // Value for the line graph
}

class PersonalPlanChart extends StatefulWidget {
  final Color mainColor;
  final Color correctColor;

  const PersonalPlanChart(
      {super.key, required this.mainColor, required this.correctColor});

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;

  @override
  void initState() {
    data = [
      ChartData('CHN', 30, 12, 18),
      ChartData('GER', 30, 15, 22),
      ChartData('RUS', 30, 25, 32),
      ChartData('BRZ', 30, 15, 20),
      ChartData('IND', 30, 14, 25),
    ];
    _tooltip = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 50, interval: 10),
          tooltipBehavior: _tooltip,
          series: <CartesianSeries>[
            // Background column representing expected values
            ColumnSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.expected,
              name: 'Expected',
              color: widget.mainColor.withOpacity(0.3),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
              width: 0.3,
            ),
          ],
        ),
        SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(minimum: 0, maximum: 50, interval: 10),
          tooltipBehavior: _tooltip,
          series: <CartesianSeries>[
            // Background column representing expected values
            ColumnSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.actual,
              name: 'Expected',
              color: widget.mainColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(50),
                topLeft: Radius.circular(50),
              ),
              width: 0.3,
            ),
            SplineSeries<ChartData, String>(
              dataSource: data,
              xValueMapper: (ChartData data, _) => data.category,
              yValueMapper: (ChartData data, _) => data.lineValue,
              name: 'Line Value',
              color: Colors.red,
              width: 5,
              dataLabelSettings: DataLabelSettings(isVisible: true),
              markerSettings: MarkerSettings(
                isVisible: true,
                shape: DataMarkerType.circle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
