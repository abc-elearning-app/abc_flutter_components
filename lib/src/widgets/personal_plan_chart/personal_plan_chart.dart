import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  final String category;
  final double expected;
  final double actual;
  final double lineValue;
  final Color barColor;
  final Color lineColor;

  ChartData(
    this.category,
    this.expected,
    this.actual,
    this.lineValue,
    this.barColor,
    this.lineColor,
  );
}

class PersonalPlanChart extends StatefulWidget {
  final Color mainColor;
  final Color correctColor;

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

  const PersonalPlanChart(
      {super.key,
      this.mainColor = const Color(0xFFE3A651),
      this.correctColor = const Color(0xFF00CA9F),
      this.minBarValue = 0,
      this.maxBarValue = 30,
      this.barValueInterval = 10,
      this.lineSectionHeight = 150,
      this.barSectionHeight = 250,
      this.minLineValue = 0,
      this.maxLineValue = 100,
      this.lineValueInterval = 50,
      this.lineWidth = 5,
      this.lineMarkerSize = 10,
      this.barRatio = 0.25});

  @override
  State<PersonalPlanChart> createState() => _PersonalPlanChartState();
}

class _PersonalPlanChartState extends State<PersonalPlanChart> {
  late List<ChartData> data;
  late TooltipBehavior _tooltip;
  late ZoomPanBehavior _zoomPanBehavior;

  @override
  void initState() {
    data = [
      ChartData('10/3', 30, 12, 50, widget.mainColor, widget.mainColor),
      ChartData('11/3', 30, 25, 52, widget.mainColor, widget.mainColor),
      ChartData('12/3', 30, 10, 55, widget.mainColor, widget.mainColor),
      ChartData('13/3', 30, 0, 60, widget.mainColor, widget.correctColor),
      ChartData('14/3', 30, 0, 65, widget.mainColor, widget.correctColor),
      ChartData('15/3', 30, 20, 70, widget.correctColor, widget.correctColor),
      ChartData('16/3', 30, 20, 70, widget.correctColor, widget.correctColor),
      ChartData('17/3', 30, 20, 70, widget.correctColor, widget.correctColor),
      ChartData('18/3', 30, 20, 70, widget.correctColor, widget.correctColor),
      ChartData('19/3', 30, 20, 70, widget.correctColor, widget.correctColor),
      ChartData('20/3', 30, 20, 70, widget.correctColor, widget.correctColor),
    ];

    _tooltip = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
    super.initState();
  }

  CategoryAxisController?
      axisController1; // create instance to axis controller for first chart
  CategoryAxisController?
      axisController2; // create instance to axis controller for second chart

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Transform.translate(
          offset: const Offset(0, 20),
          child: SizedBox(
            height: widget.lineSectionHeight,
            child: SfCartesianChart(
              onMarkerRender: (args) => _drawLineMarker(args),
              axes: _buildPlaceHolderYAxis(),
              primaryXAxis: const CategoryAxis(isVisible: false),
              primaryYAxis: NumericAxis(
                opposedPosition: true,
                minimum: widget.minLineValue,
                maximum: widget.maxLineValue,
                interval: widget.lineValueInterval,
                axisLine: const AxisLine(color: Colors.grey),
                majorTickLines: const MajorTickLines(color: Colors.grey),
                majorGridLines: const MajorGridLines(color: Colors.transparent),
              ),
              series: [
                // Expected line
                SplineSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.lineValue + 15,
                    width: widget.lineWidth,
                    color: const Color(0xFFF1D6A9),
                    markerSettings: const MarkerSettings(isVisible: false)),

                // Actual line
                SplineSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.lineValue,
                    width: widget.lineWidth,
                    pointColorMapper: (ChartData data, _) => data.lineColor,
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

        // Questions progress chart
        SizedBox(
          height: widget.barSectionHeight,
          child: Stack(
            children: [
              SfCartesianChart(
                plotAreaBorderWidth: 0,
                primaryXAxis: _buildMainXAxis(),
                primaryYAxis: _buildMainYAxis(),
                axes: _buildPlaceHolderYAxis(
                    isOpposed: true, contain3Digits: true),
                tooltipBehavior: _tooltip,
                series: [
                  StackedColumnSeries<ChartData, String>(
                    dataSource: data,
                    xValueMapper: (ChartData data, _) => data.category,
                    yValueMapper: (ChartData data, _) => data.expected,
                    name: 'Expected',
                    pointColorMapper: (ChartData data, _) =>
                        data.barColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    ),
                    width: 0.25,
                  )
                ],
              ),
              SfCartesianChart(
                  onMarkerRender: (args) => _drawLineMarker(args),
                  plotAreaBorderWidth: 0,
                  primaryXAxis: _buildMainXAxis(),
                  primaryYAxis: _buildMainYAxis(),
                  axes: _buildPlaceHolderYAxis(
                      isOpposed: true, contain3Digits: true),
                  tooltipBehavior: _tooltip,
                  zoomPanBehavior: _zoomPanBehavior,
                  onZooming: (args) {
                    if (args.axis?.name == 'primaryXAxis') {
                      // Storing the zoomPosition and the zoomFactor
                      axisController2!.zoomPosition = args.currentZoomPosition;

                      // of the first chart.
                      axisController2!.zoomFactor = args.currentZoomFactor;
                    }
                  },
                  series: <CartesianSeries>[
                    StackedColumnSeries<ChartData, String>(
                      dataSource: data,
                      xValueMapper: (ChartData data, _) => data.category,
                      yValueMapper: (ChartData data, _) => data.actual,
                      name: 'Actual',
                      pointColorMapper: (ChartData data, _) => data.barColor,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      width: 0.25,
                    ),
                  ]),
            ],
          ),
        ),
      ],
    );
  }

  _buildMainXAxis() => const CategoryAxis(
        labelStyle: TextStyle(color: Colors.transparent),
        majorTickLines: MajorTickLines(width: 0),
        majorGridLines: MajorGridLines(color: Colors.transparent),
        initialVisibleMaximum: 6,
        initialVisibleMinimum: 0,
      );

  _buildMainYAxis() => NumericAxis(
        minimum: widget.minBarValue,
        maximum: widget.maxBarValue + 2,
        interval: widget.barValueInterval,
        axisLine: const AxisLine(color: Colors.grey),
        majorGridLines: const MajorGridLines(color: Colors.transparent),
        majorTickLines: const MajorTickLines(color: Colors.grey),
      );

  _buildPlaceHolderYAxis({
    bool isOpposed = false,
    bool contain3Digits = false,
  }) =>
      [
        NumericAxis(
          plotOffset: 10,
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

  _drawLineMarker(MarkerRenderArgs args) {
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
  }
}
