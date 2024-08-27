import 'dart:convert';
import 'dart:io';

import 'package:emodiary/bar_graph/bar_graph.dart';
import 'package:emodiary/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../components/after_bgr.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/userProvider.dart';
import '../../services/event.dart';
import 'package:http/http.dart' as http;

class month_diary extends StatefulWidget {
  const month_diary({super.key});

  @override
  State<month_diary> createState() => _month_diaryState();
}

class _month_diaryState extends State<month_diary> {
  DateTime selectedDate = DateTime.now();
  int monthCheck = DateTime
      .now()
      .month - 1;
  final dateController = TextEditingController();
  final Map<DateTime, String> daysWithImages = {};

  List<double> weekly = [
    0,
    0,
    0,
    0,
    0,
    0,
  ];
  double maxValue = 0;

  List<Diary> diaries = [];
  List<Date> dates = [];

  late ValueNotifier<List<event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    String formattedDate = DateFormat('M/yyyy').format(selectedDate);
    dateController.text = formattedDate;

    final month = _getMonthFromDate(dateController.text);
    _initializeData(month);
  }

  Future<void> _initializeData(int month) async {
    await getMonthh(month.toString()); // Wait for data fetch
    setState(() {
      getdate(); // Update state after data fetch
    });
  }

  void getdate() {
    String temp = "";
    for (var date in dates) {
      for (var diary in diaries) {
        if (date.id == diary.dateId) {
          if (diary.dateId != temp) {
            DateTime dateTime = parseDateString(date.date);
            if (diary.img == "")
              daysWithImages[dateTime] = "assets/logo2.png";
            else
              daysWithImages[dateTime] = diary.img;
            temp = diary.dateId;
            break;
          }
        }
      }
    }
  }

  String? _getImageForDay(DateTime day) {
    DateTime dayToCompare = DateTime(day.year, day.month, day.day);
    if (daysWithImages.containsKey(dayToCompare)) {
      final imagePath = daysWithImages[dayToCompare];
      if (imagePath != null) {
        if (imagePath != "assets/logo2.png") {
          return imagePath;
        } else {
          File(imagePath).existsSync();
          return imagePath;
        }
      }
      return null;
    }
  }

  int _getMonthFromDate(String dateString) {
    final parts = dateString.split('/');
    return int.parse(parts[0]);
  }

  Future<void> getMonthh(String month) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var reqBody = {"userIdd": userProvider.user?.id, "monthh": month};
    var response = await http.post(
      Uri.parse(getMonth),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      var diariesList = responseData['diaries'] as List;
      var dateList = responseData['datesInMonth'] as List;

      setState(() {
        weekly = List.filled(6, 0); // Khởi tạo lại với 6 phần tử có giá trị là 0
        diaries = diariesList.map((diaryJson) => Diary.fromJson(diaryJson))
            .toList();
        if(diaries.length >0){
          for(var diary in diaries){
            if(diary.rateEmotion == 0) weekly[0]++;
            else if(diary.rateEmotion == 2) weekly[1]++;
            else if(diary.rateEmotion == 4) weekly[2]++;
            else if(diary.rateEmotion == 6) weekly[3]++;
            else if(diary.rateEmotion == 8) weekly[4]++;
            else weekly[5]++;
          }
          maxValue = weekly.reduce((curr, next) => curr > next ? curr : next);
        }
        dates = dateList.map((dateJson) => Date.fromJson(dateJson)).toList();
      });
    } else {
      print('Error');
    }
  }

  DateTime parseDateString(String dateString) {
    List<String> parts = dateString.split('/');
    if (parts.length != 3) {
      throw FormatException(
          "Invalid date format. Expected formattttt: DD/MM/YYYY");
    }

    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);

    return DateTime(year, month, day);
  }

  List<event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Map<DateTime, List<event>> events = {};

  void back() {
    Navigator.pop(context);
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
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: back,
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.all(0),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          "Monthly Diary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/logo2.png",
                            width: 50, height: 50),
                      ],
                    ),
                    TableCalendar(
                      rowHeight: 45,
                      calendarStyle: const CalendarStyle(
                        markersAlignment: Alignment.bottomRight,
                      ),
                      calendarBuilders: CalendarBuilders(
                        defaultBuilder: (context, day, focusedDay) {
                          final image = _getImageForDay(day);
                          if (image != null && image.isNotEmpty) {
                            return Container(
                              child: Stack(
                                children: [
                                  Center(
                                    child:  ClipOval(
                                      child: image == "assets/logo2.png"
                                          ? Image.asset(image, fit: BoxFit.contain, width: 34, height: 34)
                                          : Image.file(File(image), fit: BoxFit.cover, width: 34, height: 34),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          final image = _getImageForDay(day);
                          if (image != null && image.isNotEmpty) {
                            return Container(
                              child: Stack(
                                children: [
                                  Center(
                                    child:  ClipOval(
                                      child: image == "assets/logo2.png"
                                          ? Image.asset(image, fit: BoxFit.contain, width: 34, height: 34)
                                          : Image.file(File(image), fit: BoxFit.cover, width: 34, height: 34),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '${day.day}',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: Text(
                                '${day.day}',
                                style: TextStyle(color: Colors.black),
                              ),
                            );
                          }
                        },
                      ),
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      firstDay: DateTime.utc(2015, 10, 16),
                      lastDay: DateTime.now(),
                      focusedDay: selectedDate,
                      selectedDayPredicate: (day) =>
                          isSameDay(day, selectedDate),
                      onPageChanged: (DateTime focusedDay) {
                        setState(() {
                          selectedDate = focusedDay;
                          _initializeData(focusedDay.month);
                        });
                      },
                    ),
                    Expanded(child: MyBarGraph(
                      weekly: weekly,
                      maxvalue: maxValue,
                    ))
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