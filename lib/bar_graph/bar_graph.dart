import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'bar_data.dart'; // Update import to the correct path

class MyBarGraph extends StatelessWidget {
  final List<double> weekly;
  final maxvalue;
  const MyBarGraph({super.key, required this.weekly, this.maxvalue});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
      sunAmount: weekly[0],
      monAmount: weekly[1],
      tueAmount: weekly[2],
      wedAmount: weekly[3],
      thurAmount: weekly[4],
      friAmount: weekly[5],
    );
    myBarData.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: maxvalue+1,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                int index = value.toInt();
                if (index >= 0 && index < myBarData.icons.length) {
                  return Center(child: myBarData.icons[index]);
                }
                return SizedBox.shrink();
              },
            ),
          ),
        ),
        barGroups: myBarData.barData
            .map((data) => BarChartGroupData(
          x: data.x,
          barRods: [
            BarChartRodData(
                toY: data.y,
                color: nau,
                width: 25,
                borderRadius: BorderRadius.circular(2))
          ],
        ))
            .toList(),
      ),
    );
  }
}
