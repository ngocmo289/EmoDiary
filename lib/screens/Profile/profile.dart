import 'dart:io';

import 'package:emodiary/screens/Profile/change_password.dart';
import 'package:emodiary/screens/Profile/check_email.dart';
import 'package:emodiary/screens/Profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/screens/Login/sign_in.dart';
import 'package:provider/provider.dart';
import '../../components/after_bgr.dart';
import '../../provider/userProvider.dart';

Color color_btn = const Color(0xfff5deb3);
const Color xanh =  Color(0xffadd8e6);


class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {


  void editProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const edit_profile()));
  }

  void checkEmail() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const check_email()));
  }

  void logOut() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const sign_in()));
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final textName = userProvider.user?.name;
    final textEmail = userProvider.user?.email;
    final textHPBD = userProvider.user?.birthday;
    final urlImg = userProvider.user?.imgAvt;
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
                    color: Colors.white,
                  ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const Spacer(),
                      Image.asset("assets/logo2.png", width: 50, height: 50),
                    ],
                  ),
                  Expanded(
                    flex: 0,
                    child: urlImg == ""
                    ? CircleAvatar(radius: 75, backgroundColor: Colors.grey,)
                    : ClipOval(
                        child: Image.file(File(urlImg!), fit: BoxFit.cover, width: 150,height: 150,)
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      '$textName',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('$textEmail', style: TextStyle(fontSize: 17),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text('$textHPBD', style: TextStyle(fontSize: 17),),
                  ),
                  IntrinsicWidth(
                    child: ElevatedButton(
                      onPressed: editProfile,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: color_btn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  IntrinsicWidth(
                    child: ElevatedButton(
                      onPressed: checkEmail,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: color_btn,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        'Change Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                  IntrinsicWidth(
                    child: ElevatedButton(
                      onPressed: logOut,
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: xanh,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.all(10),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
