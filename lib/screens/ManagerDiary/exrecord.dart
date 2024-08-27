import 'package:flutter/material.dart';
import 'package:voice_assistant/voice_assistant.dart';
import 'package:permission_handler/permission_handler.dart';
//import "package:images_picker/images_picker.dart";

class SpeechDemo extends StatefulWidget {
  const SpeechDemo({Key? key}) : super(key: key);

  @override
  _SpeechDemoState createState() => _SpeechDemoState();
}

class _SpeechDemoState extends State<SpeechDemo> {
  String textStringValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("hihi", style: const TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 2.5,
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const VoiceTextListView()),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: const Icon(
                Icons.list_alt,
              ),
            ),
          )
        ],
      ),
      body: Center(
        /// Center is a layout widget. It takes a single child and positions it
        /// in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 300,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: VoiceToTextView(
                  micClicked: true,
                  isDoingBackgroundProcess: false,
                  listenTextStreamCallBack: (String? value) {},
                  listenTextCompleteCallBack:
                      (String? value, ActionType actionTypeValue) async {
                    if (value != null && value.isNotEmpty) {
                      setState(() {
                        textStringValue = value;
                      });
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.text_fields,
                          size: 30,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Text(
                            textStringValue,
                            style: const TextStyle(fontSize: 18),
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
    );
  }
}