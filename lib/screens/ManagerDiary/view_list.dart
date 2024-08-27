import 'dart:convert';
import 'dart:io';

import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/config.dart';
import 'package:emodiary/screens/ManagerDiary/view_detail.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emodiary/services/ex.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/after_bgr.dart';
import '../../provider/dateProvider.dart';
import 'package:http/http.dart' as http;

import '../../provider/diaryProvider.dart';
import '../../provider/userProvider.dart';

enum Actions { delete }

class view_list extends StatefulWidget {
  const view_list({super.key});

  @override
  State<view_list> createState() => _view_listState();
}

class _view_listState extends State<view_list> {
  final dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  List<Diary> diaries = [];

  void back() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const bottomNavigation(
                select: 0,
              )), // Ensure ViewListScreen is properly defined
    );
  }

  void before() {
    setState(() {
      selectedDate = selectedDate.subtract(Duration(days: 1));
      dateController.text = DateFormat('d/M/yyyy').format(selectedDate);
      checkDatee(dateController.text);
    });
  }

  void after() {
    if (selectedDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
      setState(() {
        selectedDate = selectedDate.add(Duration(days: 1));
        dateController.text = DateFormat('d/M/yyyy').format(selectedDate);
        checkDatee(dateController.text);
      });
    }
  }

  void checkDatee(String date) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var reqBody = {"userId": userProvider.user?.id, "datee": date};

    var response = await http.post(
      Uri.parse(checkDate),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      var diariesList = responseData['diaries'] as List;
      // Debug print the response data
      //print(responseData);
      setState(() {
        diaries =
            diariesList.map((diaryJson) => Diary.fromJson(diaryJson)).toList();
        print(responseData['success']);
      });
    } else {
      print('no diaries');
      setState(() {
        diaries.length = 0;
      });
    }
  }

  void delete(int index, Actions action) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      title: 'Confirm Delete',
      text: 'Are you sure you want to delete this item?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      onConfirmBtnTap: () async {
        var reqBody = {"diaryId": diaries[index].id};

        var response = await http.post(
          Uri.parse(deleteDiaryy),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody),
        );

        var jsonResponse = jsonDecode(response.body);
        print(jsonResponse['status']);
        if (jsonResponse['status']) {
          await QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            title: 'Deleted',
            text: 'Item has been successfully deleted.',
          );// Navigate back to the previous screen
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Failed to delete the item. Please try again.',
          );
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const view_list()));
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  void onItemTap(int index) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => view_detail(
                  page: 0,
                  diaryId: diaries[index].id,
                )));
    //print(diaries[index].id);
  }

  void toggleFavorite(int index) async {
    setState(() {
      // Toggle the favorite status locally
      diaries[index].favorite = !diaries[index].favorite;
    });

    // Prepare the data to be sent to the server
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    final diary = diaries[index];
    final requestBody = {
      '_id': diary.id,
      'favorite': diary.favorite,
    };
    try {
      // Send the update to the server
      final response = await http.post(
        Uri.parse(changeFavorite), // Replace with your server endpoint
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // If the server returns an error, revert the local change
        setState(() {
          //diaries[index].favorite = !diaries[index].favorite;
          print(jsonDecode(response.body)['success']);
          diaryProvider.updateDiary(favorite: diaries[index].favorite);
        });
      } else {
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update favorite status')),
        );
      }
    } catch (e) {
      // If there's an error with the request, revert the local change
      setState(() {
        diaries[index].favorite = !diaries[index].favorite;
      });
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    String formattedDate = DateFormat('d/M/yyyy').format(selectedDate);
    dateController.text = formattedDate;
    checkDatee(dateController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 30, left: 20, right: 20, top: 20),
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
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 40,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Text(
                          "View Diary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        Image.asset("assets/logo2.png", width: 50, height: 50),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                          onPressed: before,
                          icon: Icon(Icons.arrow_left),
                          iconSize: 50,
                        ),
                        Expanded(
                          child: TextField(
                            readOnly: true,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                            controller: dateController,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  selectedDate = pickedDate;
                                  dateController.text =
                                      DateFormat('d/M/yyyy').format(pickedDate);
                                  checkDatee(dateController.text);
                                });
                              }
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: after,
                          icon: Icon(Icons.arrow_right),
                          iconSize: 50,
                        )
                      ],
                    ),
                    Expanded(
                        child: diaries.isEmpty
                            ? Container(
                                margin: EdgeInsets.only(top: 100),
                                //color: Colors.green,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                      Icons.book_outlined,
                                      // Choose an appropriate icon
                                      size: 50,
                                      color:
                                          Colors.grey, // Customize icon color
                                    ),
                                    SizedBox(height: 16),
                                    // Space between icon and text
                                    Text(
                                      'No diaries in date',
                                      // Your custom message here
                                      style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Colors.grey, // Customize text color
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                itemCount: diaries.length,
                                itemBuilder: (context, index) {
                                  int reverseIndex = diaries.length - 1 - index;
                                  return Slidable(
                                      endActionPane: ActionPane(
                                        motion: const BehindMotion(),
                                        children: [
                                          SlidableAction(
                                            onPressed: (context) =>
                                                delete(reverseIndex, Actions.delete),
                                            backgroundColor: Colors.red,
                                            icon: Icons.delete,
                                            label: 'Delete',
                                          )
                                        ],
                                      ),
                                      child: GestureDetector(
                                        onTap: () => onItemTap(reverseIndex),
                                        // Handle tap event
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: xanh,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 100,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 7, // 70% của Row
                                                child: Container(
                                                  //color: Colors.red,
                                                  padding: EdgeInsets.all(5),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        diaries[reverseIndex].title,
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () =>
                                                                toggleFavorite(
                                                                    reverseIndex),
                                                            child: Icon(
                                                              diaries[reverseIndex]
                                                                      .favorite
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border,
                                                              color: diaries[
                                                              reverseIndex]
                                                                      .favorite
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Image.asset(
                                                            "assets/${diaries[reverseIndex].rateEmotion.toString()}.png",
                                                            width: 24,
                                                          ),
                                                          SizedBox(width: 10),
                                                          Visibility(
                                                            visible:
                                                                diaries[reverseIndex]
                                                                    .voice
                                                                    .isNotEmpty,
                                                            child: Icon(
                                                              Icons
                                                                  .record_voice_over,
                                                              color: Colors
                                                                  .blue, // Set the icon color if needed
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                          child: Text(
                                                        diaries[reverseIndex].story,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 3, // 30% của Row
                                                child: Container(
                                                  margin: EdgeInsets.all(5),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    // Ensure the image fits within the border radius
                                                    child: diaries[reverseIndex]
                                                            .img
                                                            .isNotEmpty
                                                        ? Image.file(File(diaries[reverseIndex].img), fit: BoxFit.cover)
                                                        : Icon(
                                                            Icons.camera_alt,
                                                            // Display a camera icon if the URL is empty
                                                            size: 50,
                                                            // Adjust the size as needed
                                                            color: Colors
                                                                .grey, // Adjust the color as needed
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                }))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
