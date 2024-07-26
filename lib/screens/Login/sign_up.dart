
import 'package:emodiary/screens/Login/sign_in.dart';
import 'package:emodiary/screens/Login/verification_code.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/btn_login.dart';

const Color brow = Color(0xffdeb887);

class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  final email_sign_up = TextEditingController();
  final pass_sign_up = TextEditingController();

  void submit(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const verificationCode(data: 1)));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(alignment: Alignment.center, children: [
        const bgr_intro(text: 'Welcome Sign Up !'),
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
                  edt_text(controller: email_sign_up, obscureText: false),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: btn_login(text: "Sign up", onPress: submit),
                  ),
                  Row(
                    children: [
                      const Text(
                        " Already have an account? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const sign_in()));
                        },
                        child: const Text(
                          "Sign In",
                          style: TextStyle(
                              fontSize: 15, decoration: TextDecoration.underline),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ))
      ]),
    );
  }
}
