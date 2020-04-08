import 'package:flutter/material.dart';

import 'package:your_chat_flutter_app/screens/home_screen.dart';
import 'package:your_chat_flutter_app/screens/authentication_screen.dart';
import 'package:your_chat_flutter_app/screens/home_screen2.dart';
import 'package:your_chat_flutter_app/screens/set_profile_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SignUpScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        Home.routeName: (ctx) => Home(),
        YourChatHomeScreen.routeName: (ctx) => YourChatHomeScreen(),
        SetProfileScreen.routeName: (ctx) => SetProfileScreen(),
      },
    );
  }
}
