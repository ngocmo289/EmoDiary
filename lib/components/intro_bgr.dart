import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class bgr_intro extends StatelessWidget {
  final String text;

  const bgr_intro({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SvgPicture.asset(
          "assets/start.svg",
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Image(
                image: AssetImage("assets/logo.png"),
                width: 200,
              ),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
