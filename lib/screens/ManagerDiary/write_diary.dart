import 'dart:convert';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/screens/ManagerDiary/view_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:voice_assistant/voice_assistant.dart' as voice;
import 'package:voice_assistant/voice_assistant.dart';
import '../../components/after_bgr.dart';
import '../../components/btn_manager_diary.dart';
import '../../config.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/noticeProvider.dart';
import '../../provider/userProvider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as p;

class write_diary extends StatefulWidget {
  const write_diary({super.key});

  @override
  State<write_diary> createState() => _write_diaryState();
}

class _write_diaryState extends State<write_diary> {
  var _image;
  String urlImg = "";

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        urlImg = pickedFile.path.toString();
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose image source'),
        actions: [
          if (_image != null) // Conditionally include the delete action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _image = null;
                });
              },
              child: Text('Delete'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  final title = TextEditingController();
  final story = TextEditingController();
  final address = TextEditingController(text: "");

  DateTime dataTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().second);
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  bool _showVoiceToText = false;
  int _selectedRating = -1;

  // Map to associate rateEmotion values with image paths
  final Map<int, String> emotionMap = {
    0: "assets/0.png",
    2: "assets/2.png",
    4: "assets/4.png",
    6: "assets/6.png",
    8: "assets/8.png",
    10: "assets/10.png",
  };

  late AudioRecorder audioRecorder;
  late AudioPlayer audioPlayer;
  String? recordingPath;
  bool isRecording = false;
  bool isPlaying = false;

  void _togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (recordingPath != null) {
        print('Recording path: $recordingPath');
        await audioPlayer.setSourceUrl(recordingPath!);
        await audioPlayer
            .resume(); // Thay vì `play`, bạn nên sử dụng `resume` nếu âm thanh đang bị dừng
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  void _toggleRecording() async {
    if (isRecording) {
      String? filePath = await audioRecorder.stop();
      if (filePath != null) {
        setState(() {
          isRecording = false;
          recordingPath = filePath;
        });
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir =
            await getApplicationDocumentsDirectory();
        final String uniqueFileName =
            Uuid().v4(); // Generate a unique identifier
        final String filePath =
            p.join(appDocumentsDir.path, "recording_$uniqueFileName.wav");
        await audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          recordingPath = null;
        });
      } else {
        // Handle permission denial
        print('Permission denied.');
      }
    }
  }

  void delete() async {
    if (recordingPath != null) {
      final File file = File(recordingPath!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          recordingPath = null; // Reset recordingPath after deleting the file
        });
        print('File deleted');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    //requestPermissions();

    recordingPath = null;
    audioRecorder = AudioRecorder();
    audioPlayer = AudioPlayer();

    DateTime dateTime =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    String formattedDate = DateFormat('d/M/yyyy').format(dateTime);
    dateController.text = formattedDate;
    timeController.text = "${DateTime.now().hour}:${DateTime.now().minute}";
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: DateTime.now(),
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              dataTime = newTime;
              dateController.text =
                  "${dataTime.day}/${dataTime.month}/${dataTime.year}";
            });
          },
          mode: CupertinoDatePickerMode.date,
          dateOrder: DatePickerDateOrder.dmy,
        ),
      ),
    );
  }

  void _showTimePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              time = newTime; // Update the `time` variable here
              timeController.text =
                  "${newTime.hour.toString()}:${newTime.minute.toString()}";
            });
          },
          mode: CupertinoDatePickerMode.time,
          use24hFormat: true,
        ),
      ),
    );
  }

  void back() {
    Navigator.pop(context);
  }

  void save() async {
    if (title.text.isNotEmpty &&
        story.text.isNotEmpty &&
        _selectedRating != -1) {
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      var reqBody = {
        "date": dateController.text,
        "userId": userProvider.user!.id,
        "title": title.text.trim(),
        "story": story.text.trim(),
        "img": urlImg,
        "voice": recordingPath == null ? "" : recordingPath,
        "rateEmotion": _selectedRating,
        "datee": dateController.text,
        "time": timeController.text,
        "address": address.text.trim(),
      };
      int noticeStatus = await checkNoticeAddressx(address.text);
      var response = await http.post(
        Uri.parse(addDiaryy),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse['status']);
      if (jsonResponse['status']) {
        dateProvider.setDate(Date.fromJson(jsonResponse['Date']));
        diaryProvider.setDiary(Diary.fromJson(jsonResponse['Diary']));
        await QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: 'Success',
          text: 'Write Diary Success',
        ).then((_) async {
          if (noticeStatus == 201) {
            await triggerNotification();
          }
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => view_detail(
                        page: 0,
                        diaryId: diaryProvider.diary!.id,
                      )));
        });
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Error',
        );
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please fill in all required fields',
      );
    }
  }

  String titleNotice = "";
  String desNotice = "";

  triggerNotification() async {
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

  Future<int> checkNoticeAddressx(String address) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final requestBody = {
      'addressx': address,
      'datenow': DateFormat('d/M/yyyy').format(DateTime.now()),
      'userIdd': userProvider.user!.id,
      'time': DateFormat('HH:mm').format(DateTime.now()),
    };

    try {
      // Send the update to the server
      final response = await http.post(
        Uri.parse(checkNoticeAddress), // Replace with your server endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('newNotice')) {
          Notice noticeGet = Notice.fromJson(jsonResponse['newNotice']);
          print('Success message: ${jsonResponse['success']}');

          setState(() {
            titleNotice = noticeGet.title;
            desNotice = noticeGet.des;
          });

          return 201;
        }
      } else {
        print('Error: ${jsonDecode(response.body)['massage']}');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
    return 404;
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
                            "Write Diary",
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
                              controller: title,
                              textAlign: TextAlign.left,
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                errorText: title.text.isEmpty
                                    ? " Enter Proper Infor "
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "Title*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          nau), // Update 'nau' to the desired color
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: _showImageSourceDialog,
                                child: AspectRatio(
                                  aspectRatio: 1.0,
                                  // 1:1 aspect ratio for equal width and height
                                  child: Container(
                                      color: Colors.grey,
                                      child: urlImg == ""
                                          ? const Center(
                                              child: Text('Select Image'))
                                          : Image.file(File(urlImg),
                                              fit: BoxFit.cover)),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: story,
                              textAlign: TextAlign.left,
                              maxLines: null,
                              onTap: () {
                                setState(() {
                                  _showVoiceToText = true; // Show the VoiceToTextView when tapped
                                });
                              },
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  _showVoiceToText = false; // Hide the VoiceToTextView when tapped outside
                                });
                              },
                              decoration: InputDecoration(
                                errorText: story.text.isEmpty
                                    ? " Enter Proper Info "
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: _showVoiceToText
                                    ? VoiceToTextView(
                                        micClicked: true,
                                        isDoingBackgroundProcess: false,
                                        listenTextStreamCallBack:
                                            (String? value) {
                                          // Handle text from voice input
                                        },
                                        listenTextCompleteCallBack:
                                            (String? value,
                                                voice.ActionType
                                                    actionTypeValue) async {
                                          if (value != null &&
                                              value.isNotEmpty) {
                                            setState(() {
                                              story.text = story.text + value;
                                            });
                                          }
                                        },
                                      )
                                    : null,
                                labelText: "Story*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          nau), // Update 'nau' to the desired color
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Voice:"),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: _toggleRecording,
                                  child: Icon(
                                      isRecording ? Icons.stop : Icons.mic),
                                ),
                                Spacer(),
                                if (recordingPath != null)
                                  ElevatedButton(
                                    onPressed: _togglePlayPause,
                                    child: Icon(Icons.record_voice_over,
                                        color: Colors.blue),
                                  ),
                                Spacer(),
                                if (recordingPath != null)
                                  ElevatedButton(
                                    onPressed: () {
                                      // Call the delete method here
                                      delete();
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Rate Story*"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children:
                                      List.generate(emotionMap.length, (index) {
                                    int rateEmotion =
                                        emotionMap.keys.elementAt(index);
                                    bool isSelected =
                                        _selectedRating == rateEmotion;
                                    return Opacity(
                                      opacity: isSelected ? 1.0 : 0.3,
                                      child: Container(
                                        child: IconButton(
                                          icon: Image.asset(
                                            emotionMap[rateEmotion]!,
                                            width: 30,
                                            height: 30,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _selectedRating =
                                                  rateEmotion; // Update selected rating index
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _showDatePicker,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey.shade800, width: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: TextField(
                                enabled: false,
                                controller: dateController,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Date*",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: InputBorder.none,
                                  hintText: "DD/MM/YYYY",
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: _showTimePicker,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey.shade800, width: 0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: TextField(
                                enabled: false,
                                controller: timeController,
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  labelText: "Time*",
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  border: InputBorder.none,
                                  hintText: "hh:mm",
                                  fillColor: Colors.white,
                                  filled: true,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            TextField(
                              controller: address,
                              textAlign: TextAlign.left,
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.all(1),
                                labelText: "  Address",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color:
                                          nau), // Update 'nau' to the desired color
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Center(
                              child: SizedBox(
                                width: 80,
                                height: 40,
                                child: btn_login(
                                    text: "Save",
                                    onPress: save,
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
