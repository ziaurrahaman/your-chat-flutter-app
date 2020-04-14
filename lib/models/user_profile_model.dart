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
<<<<<<< HEAD
  String imageUrl;
=======
  String picUrl;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
>>>>>>> c496632d10237f9144bc1412f4ab7cba5b784ec3

  UserProfile(
      {@required this.fullName,
      @required this.profileName,
      @required this.occupation,
      @required this.hobby,
      this.isActive,
      this.aToken,
      this.userId,
<<<<<<< HEAD
      this.imageUrl});
=======
      this.picUrl,
      this.createdAt,
      this.updatedAt});


  UserProfile.fromMap(Map snapshot)
      : fullName = snapshot['fullName'] ?? '',
        profileName = snapshot['profileName'] ?? '',
        occupation = snapshot['occupation'] ?? '',
        hobby = snapshot['hobby'] ?? '',
        isActive = snapshot['isActive'] ?? '',
        aToken = snapshot['atoken']!=null? snapshot['atoken'].cast<String>() : List<String>(),
        picUrl = snapshot['picUrl'] ?? '',

        createdAt =
            snapshot['createdAt'].toDate() ?? new DateTime.now(),
        updatedAt =
            snapshot['updatedAt'].toDate() ?? new DateTime.now();

>>>>>>> c496632d10237f9144bc1412f4ab7cba5b784ec3

  Map<String, dynamic> toJson(UserProfile userProfile) => {
        'fullName': userProfile.fullName,
        'profileName': userProfile.profileName,
        'occupation': userProfile.occupation,
        'hobby': userProfile.hobby,
        'token': userProfile.aToken,
<<<<<<< HEAD
        'imageUrl': userProfile.imageUrl,
        'userId': userProfile.userId
=======
        'userId': userProfile.userId,
        'picUrl': userProfile.picUrl,
        'createdAt': userProfile.createdAt,
        'updatedAt': userProfile.updatedAt,
>>>>>>> c496632d10237f9144bc1412f4ab7cba5b784ec3
      };
}
