import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bgr_after extends StatelessWidget {
  const bgr_after({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image(
          image: const AssetImage("assets/bgr_after.png"),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ],
    );
  }
}
