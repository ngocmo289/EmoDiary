import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class bgr_after extends StatelessWidget {
  const bgr_after({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Image(
        image: const AssetImage("assets/bgr_after.png"),
        fit: BoxFit.fill,
      ),
    );
  }
}
