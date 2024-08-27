import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const Color nau = Color(0xffdeb887);
const Color nau2 = Color(0xfff5deb3);
class btnManagerDiary extends StatelessWidget {
  const btnManagerDiary({super.key, required this.url, required this.text, required this.width, required this.height, required this.onPress, required this.width_img, required this.height_img});
  final double width;
  final double height;
  final double width_img;
  final double height_img;
  final String url;
  final String text;
  final Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.all(10)
        ),
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(url,alignment: Alignment.center,width: width_img, height: height_img),
              Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: nau,
              ),)
            ],
          ),
        ));
  }
}
