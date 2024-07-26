import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/screens/Login/createUser.dart';
import 'package:emodiary/screens/Login/resetPass.dart';
import 'package:flutter/material.dart';

const Color brow = Color(0xffdeb887);

class verificationCode extends StatefulWidget {
  final int data;
  const verificationCode({super.key, required this.data});

  @override
  State<verificationCode> createState() => _verificationCodeState();
}

class _verificationCodeState extends State<verificationCode> {
  final verification_code = TextEditingController();
  void submit() {
    if(widget.data == 1){
      Navigator.push(context, MaterialPageRoute(builder: (context) => const createUser()));
    }
    else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const resetPass()));
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
                  edt_text(controller: verification_code, obscureText: false),
                  btn_login(text: "Submit", onPress: submit)
                ],
              ),
            ))
      ]),
    );
  }
}
