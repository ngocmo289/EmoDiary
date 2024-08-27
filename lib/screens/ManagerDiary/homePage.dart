import 'dart:convert';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emodiary/components/after_bgr.dart';
import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:emodiary/screens/ManagerDiary/month_diary.dart';
import 'package:emodiary/screens/ManagerDiary/view_detail.dart';
import 'package:emodiary/screens/ManagerDiary/view_list.dart';
import 'package:emodiary/screens/ManagerDiary/write_diary.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../config.dart';
import '../../provider/noticeProvider.dart';
import '../../provider/userProvider.dart';
import 'favorite_list.dart';

const List<String> MONTHS = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
const List<String> weekdayName = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String imgAvt = "";
  String name = "";
  String date = weekdayName[DateTime.now().weekday - 1].toString();
  String day = DateTime.now().day.toString();
  String month = MONTHS[DateTime.now().month - 1];
  String year = DateTime.now().year.toString();
  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  Future<void> _requestNotificationPermission() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      if (!isAllowed) {
        print("Người dùng không cho phép hiển thị thông báo");
      }
    }
  }

  void write() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const write_diary()));
  }

  void view() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const view_list()));
  }

  void favorite() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const favorite_list()));
  }

  void monthdiary() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const month_diary()));
  }

  String titleNotice = "";
  String desNotice = "";

  void triggerNotification() async {
    print("title: " + titleNotice);
    if (titleNotice.isNotEmpty && desNotice.isNotEmpty) {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'EmoDiary',
            title: titleNotice,
            body: desNotice,
            largeIcon: 'assets/logo2.png' // Bật hiển thị logo
            ),
      );
    }
  }

  void checkHPBD() async {
    final userProvider = Provider.of<UserProvider>(context);
    final noticeProvider = Provider.of<NoticeProvider>(context);
    final requestBody = {
      'datenow': DateFormat('d/M/yyyy').format(DateTime.now()),
      'userIdd': userProvider.user!.id,
      'time': DateFormat('HH:mm').format(DateTime.now())
    };

    try {
      // Send the update to the server
      final response = await http.post(
        Uri.parse(checkNoticeHPBD), // Replace with your server endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      //print(response.body);
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        // Ensure the response contains the 'newNoticee' key
        if (jsonResponse.containsKey('newNoticee')) {
          Notice noticeGet = Notice.fromJson(jsonResponse['newNoticee']);
          print('Success message: ${jsonResponse['success']}');
          //print('Notice title: ${noticeGet.title}');

          setState(() {
            noticeProvider.setNotice(noticeGet);
            titleNotice = noticeGet.title;
            desNotice = noticeGet.des;
          });
          triggerNotification();
        }
      } else {
        print(jsonDecode(response.body)['massage']);
      }
    } catch (e) {
      return null;
    }
  }

  void checkMemori() async {
    final userProvider = Provider.of<UserProvider>(context);
    final noticeProvider = Provider.of<NoticeProvider>(context);
    final requestBody = {
      'datenow': DateFormat('d/M/yyyy').format(DateTime.now()),
      'userIdd': userProvider.user!.id,
      'time': DateFormat('HH:mm').format(DateTime.now())
    };

    try {
      // Send the update to the server
      final response = await http.post(
        Uri.parse(checkNoticeMemori), // Replace with your server endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );
      //print(response.body);
      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);
        // Ensure the response contains the 'newNoticee' key
        if (jsonResponse.containsKey('newNoticee')) {
          Notice noticeGet = Notice.fromJson(jsonResponse['newNoticee']);
          print('Success message: ${jsonResponse['success']}');
          //print('Notice title: ${noticeGet.title}');
          setState(() {
            noticeProvider.setNotice(noticeGet);
            titleNotice = noticeGet.title;
            desNotice = noticeGet.des;
          });
          triggerNotification();
        }
      } else {
        print(jsonDecode(response.body)['massage']);
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    name = userProvider.user!.name;
    imgAvt = userProvider.user!.imgAvt;
    checkHPBD();
    checkMemori();
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(), // Background widget
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Distribute space evenly
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // Center vertically
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            alignment: Alignment.centerRight,
                            iconSize: 25,
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(),
                              );
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Add spacing between the two widgets
                      ClipOval(
                          child: imgAvt == ""
                              ? Container(
                                  width: 40,
                                  height: 40,
                                  color: Colors.grey,
                                  child: Image.asset(
                                    'assets/userAvt.png',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.file(
                                  File(imgAvt),
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ))
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $name !",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Text("Your personal diary "),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset('assets/logo2.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Today is"),
                              Text(
                                "$date,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "$day,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                "$month,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              Text(
                                year,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: btnManagerDiary(
                                  url: "assets/write.svg",
                                  text: "Write Diary",
                                  width: 100,
                                  height: 120,
                                  onPress: write,
                                  width_img: 40,
                                  height_img: 40,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: btnManagerDiary(
                                  url: "assets/month.svg",
                                  text: "Monthly Diary",
                                  width: 100,
                                  height: 120,
                                  onPress: monthdiary,
                                  width_img: 50,
                                  height_img: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              btnManagerDiary(
                                url: "assets/view.svg",
                                text: "View Diary",
                                width: 100,
                                height: 120,
                                onPress: view,
                                width_img: 40,
                                height_img: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: btnManagerDiary(
                                  url: "assets/favorite.svg",
                                  text: "Favorite Diary",
                                  width: 100,
                                  height: 130,
                                  onPress: favorite,
                                  width_img: 50,
                                  height_img: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['apple', 'banana', 'oranges', 'pear'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> machQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        machQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = machQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
        itemCount: machQuery.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> machQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        machQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = machQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
        itemCount: machQuery.length);
  }
}
