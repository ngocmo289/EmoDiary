import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:emodiary/components/bottomNavigation.dart';
import 'package:emodiary/provider/dateProvider.dart';
import 'package:emodiary/provider/diaryProvider.dart';
import 'package:emodiary/provider/noticeProvider.dart';
import 'package:emodiary/screens/Login/createUser.dart';
import 'package:emodiary/screens/Login/sign_in.dart';
import 'package:emodiary/screens/ManagerDiary/exrecord.dart';
import 'package:emodiary/screens/ManagerDiary/write_diary.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';
import 'provider/userProvider.dart'; // Import your UserProvider

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo khởi tạo Flutter Engine
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'EmoDiary',
        channelName: 'EmoDiary Notifications',
        channelDescription: 'Notification channel for EmoDiary',
        importance: NotificationImportance.High,
      ),
    ],
    debug: true, // Tắt debug mode khi release app
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => UserProvider()),
      ChangeNotifierProvider(create: (context) => DateProvider()),
      ChangeNotifierProvider(create: (context) => DiaryProvider()),
      ChangeNotifierProvider(create: (context) => NoticeProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate, // Add this line
      ],
      supportedLocales: [
        const Locale('en', ''),
      ],
      debugShowCheckedModeBanner: false,
      home: sign_in(),
    );
  }
}
