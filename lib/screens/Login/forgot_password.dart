import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/screens/Login/verification_code.dart';
import 'package:flutter/material.dart';

const Color brow = Color(0xffdeb887);

class forgot_password extends StatefulWidget {
  const forgot_password({super.key});

  @override
  State<forgot_password> createState() => _forgot_passwordState();
}

class _forgot_passwordState extends State<forgot_password> {
  final email_reset_pass = TextEditingController();

  void cancel() {
    Navigator.pop(context);
  }

  void reset() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const verificationCode(data: 0)));
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
                  edt_text(controller: email_reset_pass, obscureText: false),
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
