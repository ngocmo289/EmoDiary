import 'package:emodiary/components/after_bgr.dart';
import 'package:emodiary/components/btn_manager_diary.dart';
import 'package:flutter/material.dart';

const List<String> MONTHS = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
const List<String> weekdayName = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String name = "mer";
  String date = weekdayName[DateTime.now().weekday - 1].toString();
  String day = DateTime.now().day.toString();
  String month = MONTHS[DateTime.now().month - 1];
  String year = DateTime.now().year.toString();

  void write() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          const bgr_after(), // Background widget
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            alignment: Alignment.topRight,
                            iconSize: 25,
                            onPressed: () {
                              showSearch(
                                context: context,
                                delegate: CustomSearchDelegate(),
                              );
                            },
                            icon: const Icon(Icons.search),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          backgroundImage: AssetImage('assets/userAvt.png'),
                          radius: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello, $name !",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Text("Your personal diary "),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        height: 200,
                        child: Image.asset('assets/logo2.png'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Today is"),
                              Text(
                                "$date,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "$day,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                "$month,",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                year,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: btnManagerDiary(
                                  url: "assets/write.svg",
                                  text: "Write Diary",
                                  width: 100,
                                  height: 120,
                                  onPress: write,
                                  width_img: 40,
                                  height_img: 40,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: btnManagerDiary(
                                  url: "assets/month.svg",
                                  text: "Monthly Diary",
                                  width: 100,
                                  height: 120,
                                  onPress: write,
                                  width_img: 50,
                                  height_img: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              btnManagerDiary(
                                url: "assets/view.svg",
                                text: "View Diary",
                                width: 100,
                                height: 100,
                                onPress: write,
                                width_img: 40,
                                height_img: 40,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: btnManagerDiary(
                                  url: "assets/favorite.svg",
                                  text: "Favorite Diary",
                                  width: 100,
                                  height: 130,
                                  onPress: write,
                                  width_img: 50,
                                  height_img: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = ['apple', 'banana', 'oranges', 'pear'];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> machQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        machQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = machQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
        itemCount: machQuery.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> machQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        machQuery.add(fruit);
      }
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          var result = machQuery[index];
          return ListTile(
            title: Text(result),
          );
        },
        itemCount: machQuery.length);
  }
}
