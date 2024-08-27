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
        Container(
          constraints: BoxConstraints.expand(),
          child: SvgPicture.asset(
            "assets/start.svg",
            fit: BoxFit.fill,
          ),
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
