import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/shift.dart';
import '../../util/constants.dart' as constants;

class Chart extends StatefulWidget {
  final List<Shift> shifts;
  const Chart({Key? key, required this.shifts}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final axisHelperColor = Colors.grey[300];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 0.70,
          child: Padding(
            padding: const EdgeInsets.only(
                right: 18.0, left: 18.0, top: 40, bottom: 12),
            child: BarChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
    );
    return Padding(
      child: Text(
        value.toInt().toString(),
        style: style,
      ),
      padding: const EdgeInsets.only(top: 8.0),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    return Text(
      value.toInt().toString(),
      style: style,
      textAlign: TextAlign.left,
    );
  }

  BarChartData mainData() {
    const cutOffYValue = 0.0;
    return BarChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) {
          if (value == 0) {
            return FlLine(color: Colors.grey[300], strokeWidth: 2);
          }
          return FlLine(
            color: axisHelperColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: const Text(constants.days),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text(constants.minutes),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: axisHelperColor!,
          width: 1,
        ),
      ),
      minY: -180,
      maxY: 180,
      baselineY: cutOffYValue,
      barGroups: getData().isNotEmpty ? getData() : getEmptyData(),
    );
  }

  List<BarChartGroupData> getEmptyData() {
    return [
      BarChartGroupData(
        x: 0,
        barsSpace: 1,
        barRods: [
          BarChartRodData(
            toY: 0,
            borderRadius: const BorderRadius.all(Radius.zero),
          ),
        ],
      )
    ];
  }

  List<BarChartGroupData> getData() {
    return widget.shifts.map((s) {
      final diff = s.end!
              .subtract(const Duration(hours: 8))
              .difference(s.start!)
              .inSeconds /
          60;
      return BarChartGroupData(
        x: s.start!.day,
        barsSpace: 1,
        barRods: [
          BarChartRodData(
            color: diff > 0 ? Colors.green[300] : Colors.pink[300],
            toY: diff,
            borderRadius: const BorderRadius.all(Radius.zero),
          ),
        ],
      );
    }).toList();
  }
}
