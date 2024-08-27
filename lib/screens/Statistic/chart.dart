import 'dart:convert';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:emodiary/config.dart';
import 'package:emodiary/line_char/line_char.dart';
import 'package:emodiary/line_char/pricePoints.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../components/after_bgr.dart';
import 'package:http/http.dart' as http;

import '../../provider/userProvider.dart';
class chart extends StatefulWidget {
  const chart({super.key});

  @override
  State<chart> createState() => _chartState();
}

class _chartState extends State<chart> {
  List<DateTime?> selectedDates = [
    null,
    null
  ]; // List to hold the start and end dates

  List<PricePoint> _pricePoints = [];


  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('d/M/yyyy');
    return formatter.format(date);
  }


  Future<void> sendDateRange(DateTime? startDate, DateTime? endDate) async {
    if (startDate == null || endDate == null) {
      print("Dates are not selected properly.");
      return;
    }
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Chuẩn bị dữ liệu để gửi lên server
    var reqBody = {
      'startDate': formatDate(startDate),
      'endDate':  formatDate(endDate),
      'userIdd': userProvider.user?.id,
    };
    //print(formatDate(startDate));
    try {
      // Gửi yêu cầu POST lên server
      final response = await http.post(
        Uri.parse(chartList),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(reqBody),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var rateList = responseData['listRate'] as List<dynamic>;
        // Define your x-values corresponding to the rateList
        final List<double> yValues = [0, 2, 4, 6, 8, 10];

        setState(() {
          // Clear the previous data
          _pricePoints.clear();

          // Update with new data
          _pricePoints = List.generate(rateList.length, (index) {
            // Get the value from rateList
            double rateValue = (rateList[index] as num).toDouble();

            // Find the index of rateValue in yValues
            int yIndex = yValues.indexOf(rateValue);

            // If yIndex is -1, it means the rateValue is not in yValues
            // You might want to handle this case accordingly
            if (yIndex == -1) {
              yIndex = 0; // Default to 0 or handle it as needed
            }

            return PricePoint(
              x: index.toDouble(), // Use the index as x
              y: yIndex.toDouble(), // Set y to the index of rateValue in yValues
            );
          });
        });
      } else {
        // Xử lý khi gửi thất bại
        print('Failed to send dates. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý khi có lỗi
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 30, left: 20, right: 20, top: 20),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Emotion Analytics",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/logo2.png", width: 50, height: 50),
                      ],
                    ),
                    CalendarDatePicker2(
                      value: selectedDates,
                      onValueChanged: (dates) {
                        if (dates.length == 2) {
                          setState(() {
                            selectedDates = dates;
                          });
                          // Gửi khoảng thời gian lên server
                          sendDateRange(selectedDates[0], selectedDates[1]);
                        }
                      },
                      config: CalendarDatePicker2Config(
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                        calendarType: CalendarDatePicker2Type
                            .range, // Ensure it's set to range mode
                      ),
                    ),
                    Expanded(
                      child: LineChartWidget(_pricePoints),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
