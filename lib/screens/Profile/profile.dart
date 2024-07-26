import 'package:emodiary/screens/Profile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:emodiary/screens/Login/sign_in.dart';
import '../../components/after_bgr.dart';

Color color_btn = const Color(0xfff5deb3);
const Color xanh =  Color(0xffadd8e6);


class profile extends StatefulWidget {
  const profile({super.key});

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  String textName = "Nguyễn Ngọc Mơ";
  String textEmail = "nguyenngocmo280902@gmail.com";
  String textHPBD = "28/09/2002";

  void editProfile() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const edit_profile()));
  }

  void changePassword() {}

  void logOut() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const sign_in()));
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
                  const CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blue,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      textName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(textEmail),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(textHPBD),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: editProfile,
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: color_btn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10)),
                        child: const Center(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                        onPressed: changePassword,
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: color_btn,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10)),
                        child: const Center(
                          child: Text(
                            'Change Password',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
                  ),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                        onPressed: logOut,
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: xanh,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10)),
                        child: const Center(
                          child: Text(
                            'Log Out',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )),
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
