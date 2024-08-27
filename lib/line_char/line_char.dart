import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:emodiary/line_char/pricePoints.dart';

class LineChartWidget extends StatelessWidget {
  final List<PricePoint> points;

  const LineChartWidget(this.points, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [
      Image.asset("assets/0.png", width: 22, height: 22,), // Sunday
      Image.asset("assets/2.png", width: 22, height: 22,), // Monday
      Image.asset("assets/4.png", width: 22, height: 22,), // Tuesday
      Image.asset("assets/6.png", width: 22, height: 22,), // Wednesday
      Image.asset("assets/8.png", width: 22, height: 22,), // Thursday
      Image.asset("assets/10.png", width: 22, height: 22,), // Friday
    ];

    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < icons.length) {
                    return Center(child: icons[index]);
                  }
                  return SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(value.toString());
                },
              ),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: points.map((point) => FlSpot(point.x, point.y)).toList(),
              isCurved: false,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}
