import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/screens/ManagerDiary/view_detail.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:emodiary/services/ex.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import '../../components/after_bgr.dart';
import '../../components/btn_manager_diary.dart';
import '../../config.dart';
import '../../provider/dateProvider.dart';
import '../../provider/diaryProvider.dart';
import '../../provider/userProvider.dart';

enum Actions { delete }

class favorite_list extends StatefulWidget {
  const favorite_list({super.key});

  @override
  State<favorite_list> createState() => _favorite_listState();
}

class _favorite_listState extends State<favorite_list> {
  String date = "";
  List<Diary> diaries = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var reqBody = {"userIdd": userProvider.user?.id};

    var response = await http.post(
      Uri.parse(getListFavorite),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      print(responseData); // Print the entire response for debugging
      var diariesList = responseData['favoriteDiaryIds'] as List;
      setState(() {
        diaries =
            diariesList.map((diaryJson) => Diary.fromJson(diaryJson)).toList();
      });
    } else if (response.statusCode == 404 || response.statusCode == 405) {
      setState(() {
        diaries = [];
      });
    } else {
      print('Unexpected status code: ${response.statusCode}');
    }
  }

  void back() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const bottomNavigation(
                select: 0,
              )), // Ensure ViewListScreen is properly defined
    );
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
          ); // Navigate back to the previous screen
        } else {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Error',
            text: 'Failed to delete the item. Please try again.',
          );
        }
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const favorite_list()));
      },
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
    );
  }

  void onItemTap(int index) {
    // Handle the tap event here
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     content: Text('Item $index tapped!'),
    //   ),
    // );
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => view_detail(
                  page: 1,
                  diaryId: diaries[index].id,
                )));
  }

  void toggleFavorite(int index) async {
    QuickAlert.show(
        context: context,
        type: QuickAlertType.confirm,
        title: 'Confirm Un-favorite',
        text: 'Are you sure you want to un-favorite this item ?',
        confirmBtnText: 'Yes',
        cancelBtnText: 'No',
        onConfirmBtnTap: () async {
          setState(() {
            // Toggle the favorite status locally
            diaries[index].favorite = false;
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const favorite_list()));
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
        },
        onCancelBtnTap: () {
          Navigator.pop(context);
        },
    );
  }

  Future<String> getDatee(int index) async {
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    var reqBody = {"dateIdd": diaries[index].dateId};

    var response = await http.post(
      Uri.parse(getDate),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      print(responseData); // Print the entire response for debugging
      Date datee =
          Date.fromJson(responseData['Datee']); // Ensure this is correct
      dateProvider.setDate(datee);
      return date = datee.date; // Ensure this matches your Date class structure
    } else {
      throw Exception('Failed to load date');
    }
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
                          "Favorite Diary",
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
                                      'No favorite diaries found',
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
                                            color: nau2,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          height: 120,
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
                                                      FutureBuilder<String>(
                                                        future: getDatee(reverseIndex),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            return Text(diaries[reverseIndex].time + ", " +
                                                                snapshot.data!);
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                'Error: ${snapshot.error}');
                                                          } else {
                                                            return CircularProgressIndicator();
                                                          }
                                                        },
                                                      ),
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
                                                                Icons.favorite,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                          SizedBox(width: 10),
                                                          Image.asset(
                                                            "assets/${diaries[reverseIndex].rateEmotion}.png",
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
