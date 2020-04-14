import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class UserProfile {
  String fullName;
  String profileName;
  String occupation;
  String hobby;
  bool isActive = false;
  List<String> aToken = [];
  String userId;
  String picUrl;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();

  UserProfile(
      {@required this.fullName,
      @required this.profileName,
      @required this.occupation,
      @required this.hobby,
      this.isActive,
      this.aToken,
      this.userId,
      this.picUrl});

  Map<String, dynamic> toJson(UserProfile userProfile) => {
        'fullName': userProfile.fullName,
        'profileName': userProfile.profileName,
        'occupation': userProfile.occupation,
        'hobby': userProfile.hobby,
        'token': userProfile.aToken,
        'imageUrl': userProfile.picUrl,
        'userId': userProfile.userId
      };
}
