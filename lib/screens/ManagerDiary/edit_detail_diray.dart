import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:emodiary/screens/ManagerDiary/view_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:record/record.dart';
import '../../components/after_bgr.dart';
import '../../components/btn_login.dart';
import '../../components/btn_manager_diary.dart';
import '../../config.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/userProvider.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';

class edit_detail_diary extends StatefulWidget {
  final int page;

  const edit_detail_diary({super.key, required this.page});

  @override
  State<edit_detail_diary> createState() => _edit_detail_diaryState();
}

class _edit_detail_diaryState extends State<edit_detail_diary> {
  TextEditingController? titleController;
  TextEditingController? storyController;
  TextEditingController? addressController;
  String voice = "";
  String? urlImgIcon;
  String urlImg = "";

  DateTime dataTime =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime time = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour, DateTime.now().second);
  final dateController = TextEditingController();
  final timeController = TextEditingController();

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
  bool isRecording = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioRecorder = AudioRecorder();
    audioPlayer = AudioPlayer();
    fetchDiaryDetails();
  }

  @override
  void dispose() {
    audioRecorder.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await audioPlayer.stop();
      setState(() {
        isPlaying = false;
      });
    } else {
      if (voice != null) {
        print('Recording path: $voice');
        await audioPlayer.setSourceUrl(voice!);
        await audioPlayer.resume();  // Thay vì `play`, bạn nên sử dụng `resume` nếu âm thanh đang bị dừng
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
          voice = filePath;
        });
      }
    } else {
      if (await audioRecorder.hasPermission()) {
        final Directory appDocumentsDir = await getApplicationDocumentsDirectory();
        final String uniqueFileName = Uuid().v4();  // Generate a unique identifier
        final String filePath = p.join(appDocumentsDir.path, "recording_$uniqueFileName.wav");
        await audioRecorder.start(const RecordConfig(), path: filePath);
        setState(() {
          isRecording = true;
          voice = "";
        });
      } else {
        // Handle permission denial
        print('Permission denied.');
      }
    }
  }


  void delete() async {
    if (voice != null) {
      final File file = File(voice!);
      if (await file.exists()) {
        await file.delete();
        setState(() {
          voice = "";  // Reset recordingPath after deleting the file
        });
        print('File deleted');
      }
    }
  }

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
          if (urlImg != "") // Conditionally include the delete action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  urlImg = "";
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


  void fetchDiaryDetails() {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final diary = diaryProvider.diary;
    if (diary != null) {
      setState(() {
        _selectedRating = diary.rateEmotion; // Update selected rating index
        titleController = TextEditingController(text: diary.title);
        storyController = TextEditingController(text: diary.story);
        addressController = TextEditingController(text: diary.address);
        dateController.text = dateProvider.date?.date ?? '';
        timeController.text = diary.time;
        voice = diary.voice;
        urlImg = diary.img;
      });
    } else {
      // Handle the case when diary is null
      print("Diary is null");
    }
  }

  void save() async {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    if (widget.page == 1) {
      bool ok = await editDiary();
      if (ok) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => view_detail(page: 1,diaryId: diaryProvider.diary!.id,)));
      } else {
        // Handle the error accordingly
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to update diary. Please try again.',
        );
      }
    } else if (widget.page == 3) {
      bool ok = await editDiary();
      if (ok) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => view_detail(page: 3,diaryId: diaryProvider.diary!.id,)));
      } else {
        // Handle the error accordingly
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to update diary. Please try again.',
        );
      }
    } else {
      bool ok = await editDiary();
      if (ok) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => view_detail(
              page: 0,
              diaryId: diaryProvider.diary!.id,
            ),
          ),
        );
      } else {
        // Handle the error accordingly
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Failed to update diary. Please try again.',
        );
      }
    }
  }

  Future<bool> editDiary() async {
    if (titleController!.text.isNotEmpty && storyController!.text.isNotEmpty) {
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      final dateProvider = Provider.of<DateProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      // print(diaryProvider.diary!.id);
      // print(titleController!.text);
      // print(storyController!.text);
      // print(dateProvider.date!.id);
      var reqBody = {
        "_id": diaryProvider.diary!.id,
        "title": titleController!.text.trim(),
        "story": storyController!.text.trim(),
        "img": urlImg,
        "voice": voice,
        "rateEmotion": _selectedRating,
        "dateId": dateProvider.date!.id,
        "date": dateController.text,
        "time": timeController.text,
        "address": addressController!.text.trim(),
        "userId": userProvider.user!.id
      };
      var response = await http.post(
        Uri.parse(editDiaryy),
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
          text: 'Edit Diary Success',
        );
        return true;
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'Error',
        );
        return false;
      }
    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error',
        text: 'Please fill in all required fields',
      );
      return false;
    }
  }

  void back() {
    Navigator.pop(context);
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

  void voiceRecor() {}

  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
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
                            "Edit Detail",
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
                              textAlign: TextAlign.left,
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              style: TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                errorText: titleController!.text.isEmpty
                                    ? "Enter Proper Infor"
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "Title*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
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
                            ),
                            SizedBox(height: 10),
                            TextField(
                              style: TextStyle(color: Colors.black),
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              controller: storyController,
                              textAlign: TextAlign.left,
                              maxLines: null,
                              // Allows TextField to grow vertically
                              decoration: InputDecoration(
                                errorText: storyController!.text.isEmpty
                                    ? " Enter Proper Infor "
                                    : null,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                labelText: "Story*",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text("Voice:"),
                                Spacer(),
                                ElevatedButton(
                                  onPressed: _toggleRecording,
                                  child: Icon(isRecording ? Icons.stop : Icons.mic),
                                ),
                                Spacer(),
                                if (voice != "")
                                  ElevatedButton(
                                    onPressed: _togglePlayPause,
                                    child: Icon(Icons.record_voice_over, color: Colors.blue),
                                  ),
                                Spacer(),
                                if (voice != "")
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
                                Text("Rate Storyyy*"),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                              style: TextStyle(color: Colors.black),
                              controller: addressController,
                              onTapOutside: (event) {
                                print('onTapOutside');
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
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
