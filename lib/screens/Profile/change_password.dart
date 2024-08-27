import 'dart:convert';

import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:emodiary/components/success.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/after_bgr.dart';
import '../../components/bottomNavigation.dart';
import '../../components/edt_text.dart';
import '../../config.dart';
import '../../provider/userProvider.dart';

class change_password extends StatefulWidget {
  const change_password({super.key});

  @override
  State<change_password> createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {

  final passwordFirst = TextEditingController();
  bool pass1 = false;
  final password = TextEditingController();
  bool pass = false;

  void save(){
    Navigator.push(context, MaterialPageRoute(builder: (context) => const bottomNavigation(select: 3)));
  }

  void submit(BuildContext context) async {
    if(password.text.isNotEmpty && passwordFirst.text.isNotEmpty){
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if(password.text.trim() == passwordFirst.text.trim()){
        var regBody = {
          "email" : userProvider.user?.email,
          "password" : password.text.trim(),
        };

        var respone = await http.post(Uri.parse(resetPassAPI),
            headers: {"Content-Type":"application/json"},
            body: jsonEncode(regBody)
        );

        var jsonRespone = jsonDecode(respone.body);

        print(jsonRespone['success']);

        if(jsonRespone['status']) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => success(
                  descript: "Changed password successfully",
                  btn_text: "Profile",
                  onPress: save,
                )
            ),
          );
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
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  //color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Reset Password",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/logo2.png", width: 50, height: 50),
                      ],
                    ),
                    SizedBox(height: 150), // Space between SVG and Text
                    Container(
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
                          edt_text(controller: password, obscureText: true, errors: pass,),
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
