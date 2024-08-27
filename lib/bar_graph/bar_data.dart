import 'package:flutter/widgets.dart';

import 'individual_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tueAmount;
  final double wedAmount;
  final double thurAmount;
  final double friAmount;

  List<IndividualBar> barData = [];

  BarData({
    required this.sunAmount,
    required this.monAmount,
    required this.tueAmount,
    required this.wedAmount,
    required this.thurAmount,
    required this.friAmount,
  });

  // Initialize bar data
  void initializeBarData() {
    barData = [
      // sun
      IndividualBar(x: 0, y: sunAmount),
      // mon
      IndividualBar(x: 1, y: monAmount),
      // tue
      IndividualBar(x: 2, y: tueAmount),
      // wed
      IndividualBar(x: 3, y: wedAmount),
      // thur
      IndividualBar(x: 4, y: thurAmount),
      // fri
      IndividualBar(x: 5, y: friAmount),
    ];
  }
  List<Widget> icons = [
    Image.asset("assets/0.png", width: 22, height: 22,), // Sunday
    Image.asset("assets/2.png", width: 22, height: 22,), // Monday
    Image.asset("assets/4.png", width: 22, height: 22,), // Tuesday
    Image.asset("assets/6.png", width: 22, height: 22,), // Wednesday
    Image.asset("assets/8.png", width: 22, height: 22,), // Thursday
    Image.asset("assets/10.png", width: 22, height: 22,), // Friday
  ];
}
