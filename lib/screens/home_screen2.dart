import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fluttertoast/fluttertoast.dart';

class YourChatHomeScreen extends StatefulWidget {
  static const routeName = 'your_chat_home_screen';
  @override
  _YourChatHomeScreenState createState() => _YourChatHomeScreenState();
}

class _YourChatHomeScreenState extends State<YourChatHomeScreen> {
  final backgroundColor = Color(0xFF283F4D);
  final containerColor = Color(0xFF112734);
  List<String> categories = ['Message', 'Online', 'Groups', 'Requests'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: <Widget>[
          
          SizedBox(
            height: 30,
          ),
          Container(
            height: 90,
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    categories[index],
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
            ),
          )
        ],
      ),
    );
  }
}
