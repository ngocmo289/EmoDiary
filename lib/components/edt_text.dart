import 'package:flutter/material.dart';

const Color brow = Color(0xffdeb887);

class edt_text extends StatelessWidget {
  final controller;
  final bool obscureText;
  final bool errors;

  const edt_text({super.key, required this.controller, required this.obscureText, this.errors = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          errorText: errors ? "Enter Proper Infor" : null,
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          fillColor: Colors.white,
          filled: true,
        ),
      ),
    );
  }
}
