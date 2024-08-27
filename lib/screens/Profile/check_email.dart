import 'dart:convert';

import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:emodiary/screens/Profile/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/after_bgr.dart';
import '../../components/edt_text.dart';
import '../../config.dart';
import '../../provider/userProvider.dart';
import '../Login/verification_code.dart';

const Color brow = Color(0xffdeb887);

class check_email extends StatefulWidget {
  const check_email({super.key});

  @override
  State<check_email> createState() => _check_emailState();
}

class _check_emailState extends State<check_email> {
  void back() {
    Navigator.pop(context);
  }

  void submit() async{
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var regBody ={
      "email" : userProvider.user?.email,
    };

    // Hiển thị QuickAlert Loading
    QuickAlert.show(
      context: context,
      type: QuickAlertType.loading,
      title: 'Please wait',
      text: 'Verification Email...',
      barrierDismissible: false,
    );

    var respone = await http.post(Uri.parse(forgot_pass),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
    );

    var jsonRespone = jsonDecode(respone.body);

    print(jsonRespone['success']);

    if(jsonRespone['status']){
      Navigator.push(context, MaterialPageRoute(builder: (context) => verificationCode(data: 3, email: userProvider.user!.email)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final email = userProvider.user?.email;
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 30, left: 20, right: 20, top: 20),
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
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: back,
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.centerLeft,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              padding: EdgeInsets.all(0),
                              iconColor: Colors.black,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 40,
                            ),
                          ),
                        ),
                        const Text(
                          "Check Email",
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
                            '"Please check your email and enter the verification code."',
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 15),
                          ),
                          TextField(
                            enabled: false,
                            textAlign: TextAlign.left,
                            decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey)),
                              hintText: email,
                            ),
                          ),
                          btn_login(text: "Submit", onPress: submit)
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
