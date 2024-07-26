import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/screens/Login/sign_in.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: profile(),
    );
  }
}
