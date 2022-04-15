import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../model/shift.dart';

class Chart extends StatefulWidget {
  final List<Shift> shifts;
  const Chart({Key? key, required this.shifts}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  final axisHelperColor = const Color(0x80cacaca);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Card(
          elevation: 3,
          child: AspectRatio(
            aspectRatio: 1.70,
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 18.0, top: 40, bottom: 12),
              child: LineChart(
                mainData(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
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

  LineChartData mainData() {
    const cutOffYValue = 0.0;
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: axisHelperColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
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
          axisNameWidget: const Text('days'),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 5,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameSize: 20,
          axisNameWidget: const Padding(
            padding: EdgeInsets.only(bottom: 2.0),
            child: Text('minutes'),
          ),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 20,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: axisHelperColor,
          width: 1,
        ),
      ),
      minX: 1,
      maxX: 35,
      minY: -80,
      maxY: 80,
      lineBarsData: [
        LineChartBarData(
          spots: widget.shifts.map(
            (shift) {
              final diff = shift.end!
                      .subtract(const Duration(hours: 8))
                      .difference(shift.start!)
                      .inSeconds /
                  60;
              return FlSpot(shift.start!.day * 1.0, diff);
            },
          ).toList(),
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          aboveBarData: BarAreaData(
            show: true,
            color: Colors.orange.withOpacity(0.5),
            cutOffY: cutOffYValue,
            applyCutOffY: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Colors.green.withOpacity(0.5),
            cutOffY: cutOffYValue,
            applyCutOffY: true,
          ),
        ),
      ],
    );
  }
}
