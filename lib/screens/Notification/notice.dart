import 'dart:convert';
import 'dart:io';

import 'package:emodiary/config.dart';
import 'package:emodiary/provider/diaryProvider.dart';
import 'package:emodiary/provider/noticeProvider.dart';
import 'package:emodiary/screens/Notification/detail_notice.dart';
import 'package:emodiary/services/notice_ex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../../components/after_bgr.dart';
import '../../components/btn_manager_diary.dart';
import '../../provider/userProvider.dart';
import '../ManagerDiary/view_detail.dart';

class notice extends StatefulWidget {
  const notice({super.key});

  @override
  State<notice> createState() => _noticeState();
}

class _noticeState extends State<notice> {
  List<Notice> notices = [];

  void onItemTap(int index) {
    String keyy= notices[index].key;
    if(notices[index].key == ""){
      keyy = notices[index].date.substring(0, notices[index].date.lastIndexOf('/'));
    }
    //Handle the tap event here
    Navigator.push(context, MaterialPageRoute(builder: (context) => detailNotice(noticeId: notices[index].id, title:  notices[index].title, keyy: keyy)));
  }

  @override
  void initState() {
    checkNotice();
    super.initState();
  }

  void checkNotice() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var reqBody = {"userIdd": userProvider.user?.id};

    var response = await http.post(
      Uri.parse(getListNotice),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      var noticeList = responseData['notice'] as List<dynamic>? ??
          []; // Debug print the response data
      //print(responseData);
      setState(() {
        notices = noticeList
            .map((noticeJson) => Notice.fromJson(noticeJson))
            .toList();
        print(responseData['massage']);
      });
    } else {
      print('no Notice');
      setState(() {
        notices.length = 0;
      });
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
            padding:
                const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
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
                        "Notification",
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
                  Expanded(
                      child: ListView.builder(
                          itemCount: notices.length,
                          itemBuilder: (context, index) {
                            int reverseIndex = notices.length - 1 - index;
                            return GestureDetector(
                              onTap: () =>
                                  notices[reverseIndex].title != "Happy Birthday !"
                                      ? onItemTap(reverseIndex)
                                      : null, // Handle tap event
                              child: Container(
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: nau2,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                height:
                                    notices[reverseIndex].title != "Happy Birthday !"
                                        ? 100
                                        : 100,
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
                                            Text(notices[reverseIndex].time +
                                                ", " +
                                                notices[reverseIndex].date),
                                            Text(
                                              notices[reverseIndex].title,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            Expanded(
                                                child: Text(
                                              notices[reverseIndex].des,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ))
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
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: notices[reverseIndex].title == "Happy Birthday !"
                                                ? Image.asset(
                                                    "assets/birthday.png",
                                                    fit: BoxFit.cover,
                                                  )
                                                : notices[reverseIndex].title ==  "Remember this ?"
                                                    ? Image.asset(
                                                        "assets/picture.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        "assets/map.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }))
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
