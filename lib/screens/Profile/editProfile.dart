import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../components/after_bgr.dart';

class edit_profile extends StatefulWidget {
  const edit_profile({super.key});

  @override
  State<edit_profile> createState() => _editProfileState();
}

class _editProfileState extends State<edit_profile> {

  final nameController = TextEditingController();
  final String name = "Nguyễn Ngọc Mơ";

  void back(){
    Navigator.pop(context);
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
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: ElevatedButton(onPressed: back,
                              style: ElevatedButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                  elevation: 0,
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                                iconColor: Colors.black,
                              ),
                            child:Icon(
                                  Icons.arrow_back,
                                size: 40,
                                ),
                            ),
                        ),
                        const Text(
                          "Edit Profile",
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
                    SizedBox(width: double.maxFinite,height: 30),
                    Container(
                      width: double.maxFinite,
                      height: 1,
                      color: Colors.grey,
                    ),
                    Container(
                      height: 50,
                      child: Row(
                        children: [
                          Text("Name: "),
                          Container(
                            color: Colors.green,
                            width: double.infinity,
                            // child: TextField(
                            //   controller: nameController,
                            //   decoration: InputDecoration(
                            //     hintText: name,
                            //     hintStyle: TextStyle(color: Colors.black),
                            //   ),
                            // ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
          ))
          ])
    );
  }
}
