import 'dart:convert';

import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/config.dart';
import 'package:emodiary/screens/Login/verification_code.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:quickalert/quickalert.dart';

const Color brow = Color(0xffdeb887);

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  final email_reset_pass = TextEditingController();
  bool _isEmailEmty = false;

  void cancel() {
    Navigator.pop(context);
  }

  void reset() async{

    if(email_reset_pass.text.isNotEmpty){
      var regBody ={
        "email" : email_reset_pass.text
      };

      var respone = await http.post(Uri.parse(forgot_pass),
          headers: {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonRespone = jsonDecode(respone.body);

      print(jsonRespone['success']);

      if(jsonRespone['status']){
        // Hiển thị QuickAlert Loading
        QuickAlert.show(
          context: context,
          type: QuickAlertType.loading,
          title: 'Please wait',
          text: 'Verification Email...',
          barrierDismissible: false,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context) => verificationCode(data: 0, email: email_reset_pass.text)));
      }else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, Email not exists, Try sign in',
        );
      }
    }else{
      setState(() {
        email_reset_pass.text.isEmpty ? _isEmailEmty = true : _isEmailEmty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(alignment: Alignment.center, children: [
        const bgr_intro(text: 'Forgot Password'),
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
                    'Email',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: email_reset_pass, obscureText: false, errors: _isEmailEmty,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: cancel,
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: brow,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.all(10)),
                            child: const Center(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                              ),
                            )),
                      ),
                      btn_login(text: "Reset password", onPress: reset)
                    ],
                  )
                ],
              ),
            ))
      ]),
    );
  }
}
