import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../components/after_bgr.dart';

class success extends StatefulWidget {
  final String descript;
  final String btn_text;
  final Function()? onPress;

  const success({super.key, required this.descript, required this.btn_text, this.onPress});

  @override
  State<success> createState() => _SuccessState();
}

class _SuccessState extends State<success> {
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
                          "Successfully",
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
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/success.svg", // Adjust height as needed
                          ),
                          SizedBox(height: 20), // Space between SVG and Text
                          Text(
                            widget.descript,
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 150), // Space between SVG and Text
                    SizedBox(
                        width: 80,
                        child: btn_login(text: widget.btn_text, onPress: widget.onPress, color: nau,))
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
