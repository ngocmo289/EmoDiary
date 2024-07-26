import 'package:emodiary/components/bottomNavigation.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/btn_login.dart';

const Color brow = Color(0xffdeb887);

class resetPass extends StatelessWidget {
  const resetPass({super.key});

  void submit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const bottomNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final passwordFirst = TextEditingController();
    final password = TextEditingController();

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
                  edt_text(controller: passwordFirst, obscureText: false),
                  const Text(
                    'Enter Password',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(controller: password, obscureText: true),
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
