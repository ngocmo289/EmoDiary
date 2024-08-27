import 'dart:convert';
import 'dart:io';

import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:emodiary/screens/Notification/notice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../components/after_bgr.dart';
import '../../components/bottomNavigation.dart';
import '../../config.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/noticeProvider.dart';
import '../../provider/userProvider.dart';
import '../Profile/profile.dart';

class detailNotice extends StatefulWidget {
  final String noticeId;
  final String title;
  final String keyy;

  const detailNotice(
      {super.key,
      required this.noticeId,
      required this.title,
      required this.keyy});

  @override
  State<detailNotice> createState() => _detailNoticeState();
}

class _detailNoticeState extends State<detailNotice> {
  List<Diary> diaries = [];
  String date = "";

  void back() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const bottomNavigation(
                select: 2,
              )), // Ensure ViewListScreen is properly defined
    );
  }

  @override
  void initState() {
    checkNoticeDatail();
    super.initState();
  }

  Future<String> getDatee(int index) async {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    var reqBody = {"dateIdd": diaries[index].dateId};

    var response = await http.post(
      Uri.parse(getDate),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      print(responseData); // Print the entire response for debugging
      Date datee =
          Date.fromJson(responseData['Datee']); // Ensure this is correct
      dateProvider.setDate(datee);
      return date = datee.date; // Ensure this matches your Date class structure
    } else {
      throw Exception('Failed to load date');
    }
  }

  void checkNoticeDatail() async {
    if (widget.title == "Remember this ?") {
      var reqBody = {"noticeId": widget.noticeId};

      var response = await http.post(
        Uri.parse(getListMemory),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var diariesList = responseData['diaries'] as List;
        // Debug print the response data
        //print(responseData);
        setState(() {
          diaries = diariesList
              .map((diaryJson) => Diary.fromJson(diaryJson))
              .toList();
          print(responseData['success']);
        });
      } else {
        print('no diaries');
        setState(() {
          diaries.length = 0;
        });
      }
    } else {
      var reqBody = {"noticeId": widget.noticeId};

      var response = await http.post(
        Uri.parse(getListAddress),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      if (response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var diariesList = responseData['diaries'] as List;
        // Debug print the response data
        //print(responseData);
        setState(() {
          diaries = diariesList
              .map((diaryJson) => Diary.fromJson(diaryJson))
              .toList();
          print(responseData['success']);
        });
      } else {
        print('no diaries');
        setState(() {
          diaries.length = 0;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          const bgr_after(),
          SafeArea(
              child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
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
                        "View Detail",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const Spacer(),
                      Image.asset("assets/logo2.png", width: 50, height: 50),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    widget.keyy,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                      child: ListView.builder(
                          itemCount: diaries.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = diaries.length - 1 - index;
                            return Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color:widget.title == "Remember this ?" ? nau2 : xanh,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height: 120,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 7, // 70% của Row
                                      child: Container(
                                        //color: Colors.red,
                                        padding: EdgeInsets.all(5),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FutureBuilder<String>(
                                              future: getDatee(reverseIndex),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasData) {
                                                  return Text(
                                                      diaries[reverseIndex].time +
                                                          ", " +
                                                          snapshot.data!);
                                                } else if (snapshot.hasError) {
                                                  return Text(
                                                      'Error: ${snapshot.error}');
                                                } else {
                                                  return CircularProgressIndicator();
                                                }
                                              },
                                            ),
                                            Text(
                                              "Title: ${diaries[reverseIndex].title}",
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Rate: ",
                                                ),
                                                SizedBox(width: 10),
                                                Image.asset(
                                                  "assets/${diaries[reverseIndex].rateEmotion.toString()}.png",
                                                  width: 24,
                                                ),
                                                SizedBox(width: 10),
                                                Visibility(
                                                  visible: diaries[reverseIndex]
                                                      .voice
                                                      .isNotEmpty,
                                                  child: Icon(
                                                    Icons.record_voice_over,
                                                    color: Colors
                                                        .blue, // Set the icon color if needed
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                                child: Text(
                                              "Story: ${diaries[reverseIndex].story}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            )),
                                            diaries[reverseIndex].address != ""
                                                ? Expanded(
                                                    child: Text(
                                                      "Address: ${diaries[reverseIndex].address}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                    ),
                                                  )
                                                : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3, // 30% của Row
                                      child: Container(
                                        margin: EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // Ensure the image fits within the border radius
                                          child: diaries[reverseIndex].img.isNotEmpty
                                              ? Image.file(
                                                  File(diaries[reverseIndex].img),
                                                  fit: BoxFit.cover)
                                              : Icon(
                                                  Icons.camera_alt,
                                                  // Display a camera icon if the URL is empty
                                                  size: 50,
                                                  // Adjust the size as needed
                                                  color: Colors
                                                      .grey, // Adjust the color as needed
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }))
                ],
              ),
            ),
          ))
        ]));
  }
}
