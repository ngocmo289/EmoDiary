import 'dart:convert';
import 'dart:io';

import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/components/btn_login.dart';
import 'package:emodiary/components/success.dart';
import 'package:emodiary/config.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import '../../components/after_bgr.dart';
import '../../provider/userProvider.dart';

const Color nau = Color(0xffdeb887);

class edit_profile extends StatefulWidget {
  const edit_profile({super.key});

  @override
  State<edit_profile> createState() => _editProfileState();
}

class _editProfileState extends State<edit_profile> {
  final nameController = TextEditingController();
  bool _isname = false;
  final birthdayController = TextEditingController();
  String imgUrl = "";
  String name ="";
  String email="";
  void back() {
    Navigator.pop(context);
  }

  void back_profile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const bottomNavigation(select: 3)));
  }


  void save() async {
    if (nameController.text.isNotEmpty && birthdayController.text.isNotEmpty) {
      print(birthdayController.text);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      var reqBody = {
        "email": userProvider.user?.email,
        "name": nameController.text,
        "birthday": birthdayController.text,
        "imgAvt": imgUrl
      };

      try {
        var response = await http.post(
          Uri.parse(editProfile),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody),
        );

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status']) {
          userProvider.updateUser(
            birthday: birthdayController.text,
            name: nameController.text,
            imgAvt: imgUrl,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => success(
                descript: "Changed profile successfully",
                btn_text: "Profile",
                onPress: back_profile, // Pass the function reference
              ),
            ),
          );
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: jsonResponse['message'] ?? 'Failed to update profile',
          );
        }
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Error',
          text: 'An error occurred. Please try again.',
        );
      }
    } else {
      setState(() {
        _isname = nameController.text.isEmpty;
      });

      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Please fill in all fields.',
      );
    }
  }

  DateTime dataTime = DateTime(2002, 1, 1);

  void _showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => SizedBox(
        height: 250,
        child: CupertinoDatePicker(
          backgroundColor: Colors.white,
          initialDateTime: dataTime,
          maximumDate: DateTime.now(),
          onDateTimeChanged: (DateTime newTime) {
            setState(() {
              dataTime = newTime;
              birthdayController.text =
                  "${dataTime.day}/${dataTime.month}/${dataTime.year}";
            });
          },
          mode: CupertinoDatePickerMode.date,
          dateOrder: DatePickerDateOrder.dmy,
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose image source'),
        actions: [
          if (imgUrl != "") // Conditionally include the delete action
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  imgUrl = "";
                });
              },
              child: Text('Delete'),
            ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
            },
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.gallery);
            },
            child: Text('Gallery'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imgUrl = pickedFile.path.toString();
      });
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    email = userProvider.user!.email;
    name = userProvider.user!.name;
    imgUrl = userProvider.user!.imgAvt;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
          const bgr_after(),
          SafeArea(
              child: Padding(
            padding:
                const EdgeInsets.only(bottom: 30, left: 20, right: 20, top: 20),
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
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: back,
                          style: ElevatedButton.styleFrom(
                            alignment: Alignment.centerLeft,
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            padding: EdgeInsets.all(0),
                            iconColor: Colors.black,
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            size: 40,
                          ),
                        ),
                      ),
                      const Text(
                        "Edit Profile",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      const Spacer(),
                      Image.asset("assets/logo2.png", width: 50, height: 50),
                    ],
                  ),
                  GestureDetector(
                      onTap: _showImageSourceDialog,
                      child: Center(
                          child: ClipOval(
                        child: imgUrl == ""
                                ? Icon(
                                    Icons.camera_alt,
                                    size: 30,
                                    color: nau,
                                  )
                                : Image.file(
                                    File(imgUrl),
                                    fit: BoxFit.cover,
                                    width: 150,
                                    height: 150,
                                  )
                        ),
                      )),
                  SizedBox(width: double.maxFinite, height: 30),
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        controller: nameController,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: "Name",
                          errorText: _isname ? "Enter Proper Infor" : null,
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '$name',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: nau),
                          ),
                        ),
                      )),
                  SizedBox(width: double.maxFinite, height: 30),
                  Directionality(
                      textDirection: TextDirection.ltr,
                      child: TextField(
                        enabled: false,
                        textAlign: TextAlign.left,
                        decoration: new InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey)),
                          labelText: "Email",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: '$email',
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: nau),
                          ),
                        ),
                      )),
                  SizedBox(width: double.maxFinite, height: 30),
                  ElevatedButton(
                    onPressed: _showDatePicker,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: EdgeInsets.all(0),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.shade800),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: TextField(
                      enabled: false,
                      controller: birthdayController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Your Birthday",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: InputBorder.none,
                        hintText: "DD/MM/YYYY",
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(width: double.maxFinite, height: 60),
                  SizedBox(
                      width: 80,
                      height: 40,
                      child: btn_login(
                        text: "Save",
                        onPress: save,
                        color: nau,
                      ))
                ],
              ),
            ),
          ))
        ]));
  }
}
