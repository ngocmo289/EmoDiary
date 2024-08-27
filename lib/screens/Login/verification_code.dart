import 'dart:convert';

import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/screens/Login/createUser.dart';
import 'package:emodiary/screens/Login/resetPass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/quickalert.dart';
import '../../config.dart';
import '../Profile/change_password.dart';

const Color brow = Color(0xffdeb887);

class verificationCode extends StatefulWidget {
  final int data;
  final String email;
  const verificationCode({super.key, required this.data, this.email= ""});

  @override
  State<verificationCode> createState() => _verificationCodeState();
}

class _verificationCodeState extends State<verificationCode> {
  final verification_code = TextEditingController();
  bool _isemty = false;
  void submit() async{
    if(widget.data == 1){
      if(verification_code.text.isNotEmpty){
        var regBody ={
          "type_code" : verification_code.text
        };
        final response = await http.post(
            Uri.parse(verification),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody)
        );

        var jsonRespone = jsonDecode(response.body);
        print(jsonRespone['success']);

        if(jsonRespone['status']){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => createUser(email: widget.email),
            ),
          );
        }else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Incorrect verification code, Try again ! ',
          );
        }
      }else{
        setState(() {
          verification_code.text.isEmpty ? _isemty = true : _isemty = false;
        });
      }
    }
    else {
      if(verification_code.text.isNotEmpty){
        var regBody ={
          "type_code" : verification_code.text
        };
        final response = await http.post(
            Uri.parse(verification),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(regBody)
        );

        var jsonRespone = jsonDecode(response.body);

        print(jsonRespone['success']);

        if(jsonRespone['status']){
          if(widget.data ==3){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const change_password()));
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => resetPass(email: widget.email,)));
          }
        }else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Incorrect verification code, Try again ! ',
          );
        }
      }else{
        setState(() {
          verification_code.text.isEmpty ? _isemty = true : _isemty = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(alignment: Alignment.center, children: [
        const bgr_intro(text: 'Verification Code'),
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
                    '"Please check your email and enter the verification code."',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: verification_code, obscureText: false, errors: _isemty),
                  btn_login(text: "Submit", onPress: submit)
                ],
              ),
            ))
      ]),
    );
  }
}
