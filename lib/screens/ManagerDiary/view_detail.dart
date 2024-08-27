import 'dart:convert';
import 'dart:io';

import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/config.dart';
import 'package:emodiary/screens/ManagerDiary/edit_detail_diray.dart';
import 'package:emodiary/screens/ManagerDiary/favorite_list.dart';
import 'package:emodiary/screens/ManagerDiary/view_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import '../../components/after_bgr.dart';
import '../../components/btn_login.dart';
import '../../components/btn_manager_diary.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/userProvider.dart';
import 'package:audioplayers/audioplayers.dart';

class view_detail extends StatefulWidget {
  final int page;
  final String diaryId;

  const view_detail({super.key, required this.page, this.diaryId = ""});

  @override
  State<view_detail> createState() => _view_detailState();
}

class _view_detailState extends State<view_detail> {
  TextEditingController? titleController;
  TextEditingController? storyController;
  TextEditingController? addressController;
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  String voice = "";
  String? urlImgIcon;
  String urlImg = "";


  late AudioRecorder audioRecorder;
  late AudioPlayer audioPlayer;
  bool isPlaying = false;



  @override
  void initState() {
    super.initState();
    audioRecorder = AudioRecorder();
    audioPlayer = AudioPlayer();
    // Fetch diary details
    fetchDiaryDetails();
  }

  void fetchDiaryDetails() async {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);

    var reqBody = {"id": widget.diaryId}; // Corrected key

    try {
      final response = await http.post(
        Uri.parse(detailDiary), // Replace with your server endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );

      // print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Check if the 'Diary' key exists in the response
        if (responseData.containsKey('Diary')) {
          Diary diary = Diary.fromJson(
              responseData['Diary']); // Assuming Diary.fromJson exists
          //print('Diary fetched: ${diary.dateId}');
          // Update provider and state
          diaryProvider.setDiary(diary);
          Date date = Date.fromJson(responseData['Date']);
          dateProvider.setDate(date);
          // Initialize text controllers if necessary
          setState(() {
            titleController = TextEditingController(text: diary.title);
            storyController = TextEditingController(text: diary.story);
            addressController = TextEditingController(text: diary.address);
            dateController.text = date.date;
            timeController.text = diary.time;
            urlImgIcon = "assets/${diary.rateEmotion}.png";
            voice = diary.voice;
            urlImg = diary.img;
          });
        } else {
          // Handle case where 'Diary' key is missing
          print('Diary key not found in response');
        }
      } else {
        // Handle unexpected status codes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to fetch diary details. Status code: ${response.statusCode}')),
        );
      }
    } catch (e) {
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  void back() {
    if (widget.page == 1) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const favorite_list()));
    } else if (widget.page == 3) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const bottomNavigation(
                    select: 2,
                  )));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const view_list()));
    }
    //Navigator.pop(context);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => const view_list()));
  }

  void Edit() {
    if (widget.page == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const edit_detail_diary(
                    page: 1,
                  )));
    } else if (widget.page == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const edit_detail_diary(page: 3)),
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const edit_detail_diary(
                    page: 0,
                  )));
    }
  }

  void voiceRecor() async{
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    }else {
      if (voice != "") {
        print('Recording path: $voice');
        await audioPlayer.setSourceUrl(voice!);
        await audioPlayer.resume(); // Thay vì `play`, bạn nên sử dụng `resume` nếu âm thanh đang bị dừng
        setState(() {
          isPlaying = true;
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
                padding: const EdgeInsets.only(
                    bottom: 30, left: 20, right: 20, top: 20),
                child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Column(children: [
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
                                iconColor: Colors.black,
                              ),
                              child: Icon(
                                Icons.arrow_back,
                                size: 40,
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
                          Image.asset("assets/logo2.png",
                              width: 50, height: 50),
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.all(8),
                          children: [
                            TextField(
                              controller: titleController,
                              enabled: false,
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                labelText: "Title*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AspectRatio(
                                aspectRatio: 1.0,
                                // 1:1 aspect ratio for equal width and height
                                child: Container(
                                  color: Colors.grey,
                                  child:
                                  urlImg == ""
                                      ? Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                      color: nau,
                                  ) :
                                  Image.file(File(urlImg), fit: BoxFit.cover)
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              enabled: false,
                              style: TextStyle(color: Colors.black),
                              controller: storyController,
                              textAlign: TextAlign.left,
                              maxLines: null,
                              // Allows TextField to grow vertically
                              decoration: InputDecoration(
                                labelText: "Story*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Voice:"),
                                voice != ""
                                    ? IconButton(
                                        onPressed: voiceRecor,
                                        icon: Icon(Icons.record_voice_over, color: Colors.blue,))
                                    : IconButton(
                                        onPressed: null,
                                        icon: Icon(Icons.voice_over_off)),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Rate Story*"),
                                SizedBox(
                                  width: 25,
                                ),
                                if (urlImgIcon != null)
                                  Image.asset(
                                    urlImgIcon!,
                                    width: 30,
                                    height: 30,
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            TextField(
                              enabled: false,
                              controller: dateController,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Date*",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "DD/MM/YYYY",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              enabled: false,
                              controller: timeController,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Time*",
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintText: "hh:mm",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              enabled: false,
                              style: TextStyle(color: Colors.black),
                              controller: addressController,
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(1),
                                labelText: "  Address",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: SizedBox(
                                width: 80,
                                height: 40,
                                child: btn_login(
                                    text: "Edit",
                                    onPress: Edit,
                                    color: nau), // Update color as needed
                              ),
                            ),
                          ],
                        ),
                      )
                    ]))))
      ]),
    );
  }
}
