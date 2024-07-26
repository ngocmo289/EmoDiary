import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';

import '../../components/bottomNavigation.dart';

const Color brow = Color(0xffdeb887);

class createUser extends StatefulWidget {
  const createUser({super.key});

  @override
  State<createUser> createState() => _createUserState();
}

class _createUserState extends State<createUser> {
  void submit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const bottomNavigation()),
    );
  }
  final passwordFirst = TextEditingController();
  final password = TextEditingController();
  final userName = TextEditingController();
  DateTime dataTime = DateTime(2002, 1, 1);

  final birthdayController = TextEditingController();

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: dataTime,
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              dataTime = newTime;
              birthdayController.text =
              "${dataTime.month}/${dataTime.day}/${dataTime.year}";
            });
          },
          mode: CupertinoDatePickerMode.date,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const bgr_intro(text: 'Create Account'),
          Positioned(
            top: 270,
            child: Container(
              padding: const EdgeInsets.all(15),
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: brow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: passwordFirst, obscureText: false),
                  const Text(
                    'Enter Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: password, obscureText: true),
                  const Text(
                    'Your Name',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: userName, obscureText: false),
                  const Text(
                    'Your Birthday',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  ElevatedButton(
                    onPressed: _showDatePicker,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: TextField(
                      enabled: false,
                      controller: birthdayController,
                      decoration: const InputDecoration(
                        hintText: "MM/DD/YYYY",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: btn_login(text: "Submit", onPress: () => submit(context)),
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
