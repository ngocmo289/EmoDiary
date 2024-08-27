import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const Color bgr =  Color(0xff2c2c2c);
class btn_login extends StatelessWidget {
  final Color color;

  final String text;

  final Function()? onPress;

  const btn_login({
    Key? key,
    required this.text,
    required this.onPress,
    this.color = bgr,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color,
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
