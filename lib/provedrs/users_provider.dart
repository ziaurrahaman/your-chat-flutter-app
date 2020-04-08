import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';

class UserProfile with ChangeNotifier {
  String fullName;
  String profileName;
  String occupation;
  String hobby;
  bool isActive = false;
  List<String> aToken = [];

  UserProfile(
      {@required this.fullName,
      @required this.profileName,
      @required this.occupation,
      @required this.hobby,
      this.isActive,
      this.aToken});

  Map<String, dynamic> toJson(UserProfile userProfile) => {
        'fullName': userProfile.fullName,
        'profileName': userProfile.profileName,
        'occupation': userProfile.occupation,
        'hobby': userProfile.hobby,
        'token': userProfile.aToken
      };
  Future<void> saveDataToDatabase(File image, String fullName,
      String profileName, String occupation, String hobby) async {
    if (image == null) {
      Fluttertoast.showToast(msg: 'Please Select an Image');
    }
  }
}
