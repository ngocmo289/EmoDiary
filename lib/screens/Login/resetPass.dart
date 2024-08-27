import 'dart:convert';

import 'package:emodiary/components/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/btn_login.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import '../../provider/userProvider.dart';

const Color brow = Color(0xffdeb887);
class resetPass extends StatefulWidget {
  final String email;
  const resetPass({super.key, this.email = ""});

  @override
  State<resetPass> createState() => _resetPassState();
}

class _resetPassState extends State<resetPass> {
  final passwordFirst = TextEditingController();
  bool pass1 = false;
  final password = TextEditingController();
  bool pass = false;

  void submit(BuildContext context) async{
    if(password.text.isNotEmpty && passwordFirst.text.isNotEmpty){
      if(password.text.trim() == passwordFirst.text.trim()){
        print(widget.email);
        var regBody = {
          "email" : widget.email,
          "password" : password.text.trim(),
        };

        var respone = await http.post(Uri.parse(resetPassAPI),
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
      }else{
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'The passwords do not match. Please try again.',
        );
      }
    }else{
      setState(() {
        passwordFirst.text.isEmpty ? pass1 = true : false;
        password.text.isEmpty ? pass = true : false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const bgr_intro(text: 'Reset Password'),
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
                  edt_text(controller: passwordFirst, obscureText: false, errors: pass1,),
                  const Text(
                    'Enter Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: password, obscureText: true,errors: pass,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: btn_login(
                      text: "Submit",
                      onPress: () => submit(context),
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
