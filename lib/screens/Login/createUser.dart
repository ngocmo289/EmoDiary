import 'dart:convert';

import 'package:emodiary/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import '../../components/bottomNavigation.dart';
import '../../provider/userProvider.dart';

const Color brow = Color(0xffdeb887);

class createUser extends StatefulWidget {
  final String email;
  const createUser({super.key, required this.email});

  @override
  State<createUser> createState() => _createUserState();
}

class _createUserState extends State<createUser> {


  final passwordFirst = TextEditingController();
  bool pass1 = false;
  final password = TextEditingController();
  bool pass = false;
  final userName = TextEditingController();
  bool name = false;
  DateTime dataTime = DateTime(2002, 1, 1);

  final birthdayController = TextEditingController();


  void submit(BuildContext context) async {
    if (passwordFirst.text.isNotEmpty &&
        password.text.isNotEmpty &&
        userName.text.isNotEmpty &&
        birthdayController.text.isNotEmpty) {
      if (passwordFirst.text == password.text) {
        var regBody ={
          "email" : widget.email,
          "password" : password.text,
          "name" : userName.text,
          "birthday" : birthdayController.text,
          "imgAvt" : ""
        };

        var respone = await http.post(Uri.parse(createAccount),
            headers: {"Content-Type":"application/json"},
            body: jsonEncode(regBody)
        );

        var jsonRespone = jsonDecode(respone.body);

        print(jsonRespone['success']);

        if(jsonRespone['status']) {

          var user = User(
            jsonRespone['user']['_id'],
            jsonRespone['user']['email'],
            jsonRespone['user']['password'],
            jsonRespone['user']['birthday'],
            jsonRespone['user']['name'],
            jsonRespone['user']['imgAvt'],
          );
          // Lưu thông tin người dùng vào UserProvider
          print(user.email);
          Provider.of<UserProvider>(context, listen: false).setUser(user);

          Navigator.push(context, MaterialPageRoute(
              builder: (context) => const bottomNavigation(select: 0)));
        }
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'The passwords do not match. Please try again.',
        );
      }
    } else {
      if (birthdayController.text.isEmpty) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Please fill in birthday fields.',
        );
      }
      setState(() {
        passwordFirst.text.isEmpty ? pass1 = true : false;
        password.text.isEmpty ? pass1 = true : false;
        userName.text.isEmpty ? pass1 = true : false;
      });
    }
  }


  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: dataTime,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              dataTime = newTime;
              birthdayController.text =
                  "${dataTime.day}/${dataTime.month}/${dataTime.year}";
            });
          },
          mode: CupertinoDatePickerMode.date,
          dateOrder: DatePickerDateOrder.dmy,
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
                  edt_text(
                    controller: passwordFirst,
                    obscureText: false,
                    errors: pass1,
                  ),
                  const Text(
                    'Enter Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(
                    controller: password,
                    obscureText: true,
                    errors: pass,
                  ),
                  const Text(
                    'Your Name',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(
                    controller: userName,
                    obscureText: false,
                    errors: name,
                  ),
                  const Text(
                    'Your Birthday',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  ElevatedButton(
                    onPressed: _showDatePicker,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: TextField(
                      enabled: false,
                      controller: birthdayController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "DD/MM/YYYY",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: btn_login(
                        text: "Submit", onPress: () => submit(context)),
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
