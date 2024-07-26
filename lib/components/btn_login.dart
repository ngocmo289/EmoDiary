import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Color bgr = const Color(0xff2c2c2c);
class btn_login extends StatelessWidget {
  const btn_login({super.key, required this.text, required this.onPress});

  final String text;

  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: bgr,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(10)
      ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 15,
            ),
          ),
        ),
      );
  }
}
