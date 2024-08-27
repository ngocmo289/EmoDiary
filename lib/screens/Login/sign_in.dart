import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:emodiary/components/edt_text.dart';
import 'package:emodiary/components/intro_bgr.dart';
import 'package:emodiary/screens/Login/forgot_password.dart';
import 'package:emodiary/screens/Login/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/bottomNavigation.dart';
import '../../config.dart';
import '../../provider/userProvider.dart';
import '/components/btn_login.dart';
import 'package:http/http.dart' as http;

class sign_in extends StatefulWidget {
  const sign_in({super.key});

  @override
  State<sign_in> createState() => _Sign_inState();
}

class _Sign_inState extends State<sign_in> {
  final Color brow = const Color(0xffdeb887);

  //edit Text
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isvalidatename = false;
  bool _isvalidatepass = false;


  void submit(BuildContext context) async {
    if(userNameController.text.isNotEmpty && passwordController.text.isNotEmpty ){
      var regBody ={
        "email" : userNameController.text.trim(),
        "password": passwordController.text.trim()
      };

      var respone = await http.post(Uri.parse(login),
        headers: {"Content-Type":"application/json"},
        body: jsonEncode(regBody)
      );

      var jsonRespone = jsonDecode(respone.body);

      print(jsonRespone['message']);
      //print(jsonRespone); // In ra toàn bộ phản hồi để kiểm tra cấu trúc
      if(jsonRespone['status']){
        // Lấy thông tin người dùng từ API phản hồi
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const bottomNavigation(select: 0,)));
      } else {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Invalid email or password. Try again !',
        );
      }
    }else{
      setState(() {
        userNameController.text.isEmpty ? _isvalidatename = true : _isvalidatename = false;
        passwordController.text.isEmpty ? _isvalidatepass = true : _isvalidatepass = false;
      });
    }
  }

  void signUp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const sign_up()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          const bgr_intro(text: "Welcome EmoDiary !"),
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
                  edt_text(
                    controller: userNameController,
                    obscureText: false,
                    errors: _isvalidatename,
                  ),
                  const Text(
                    'Password ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 15),
                  ),
                  edt_text(
                    controller: passwordController,
                    obscureText: true,
                    errors: _isvalidatepass,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const forgot_password()));
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Forgot password? ',
                          style: TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: btn_login(text: 'Sign in',onPress: () => submit(context)),
                  ),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => const sign_up()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 15, decoration: TextDecoration.underline),
                        ),
                      )
                    ],
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
