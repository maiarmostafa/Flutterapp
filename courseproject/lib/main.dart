import 'package:courseproject/Screens/notfi.dart';
import 'package:flutter/material.dart';
import 'package:courseproject/Screens/login.dart';
import 'package:courseproject/Screens/home.dart';
import 'package:courseproject/Screens/RegesterPage.dart';
import 'package:courseproject/Screens/profilepp.dart';
import 'package:courseproject/Screens/listcourses.dart';
import 'Screens/notificationsScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Pacifico',primarySwatch: Colors.grey),
      initialRoute: '/',
      routes: {
        '/': (context) => MyHomePage(),
        '/login': (context) => LoginPage(),
        '/Regester': (context) => RegesterPage(),
        '/profile': (context) => Profilepage(),
        '/listcourse':(context)=> Listcourses(),
        '/notification':(context)=>NotficationScreen(),
        '/notfi':(context)=>NotfiPage()
      },
    );
  }
}
