import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_chat_flutter_app/models/user_profile_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';
// import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:your_chat_flutter_app/models/user_profile_model.dart';
import 'package:your_chat_flutter_app/models/user_profile_model.dart';

class SetProfileScreen extends StatefulWidget {
  static const routeName = 'set_profile_screen';

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  File _pickedImage;
  String fullName = '';
  String profileName = '';
  String occupation = '';
  String hobby = '';
  String tokenString = '';
  String userId;
  String imageUrl;
  ProgressDialog pro;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences _sharedPreferences;

  Future<void> _showOptionsDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Make a Choice'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text('Galery'),
                      onTap: _pickImageFromGallery,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      child: Text('Camera'),
                      onTap: _pickImageFromCamera,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _firebaseMessaging.getToken().then((token) {
      final tokenStr = token.toString();
      tokenString = token;
      print("Token: " + tokenString);
    });

    setProgressDialogue();
    getTheCurrentUSerInfo();
  }

  getTheCurrentUSerInfo() async {
    this.userId = '';
    FirebaseAuth.instance.currentUser().then((val) {
      setState(() {
        this.userId = val.uid;
        print('UserId: $userId');
        print('UserIdInInteger: ${userId.hashCode.toString()}');
      });
    }).catchError((e) {
      print(e);
    });
  }

  setProgressDialogue() {
    pro = new ProgressDialog(context);
    pro = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pro.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
    );
  }

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 150, maxWidth: 150);
    setState(() {
      _pickedImage = image;
      //  File file=image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _pickImageFromCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = image;
      // file=image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_pickedImage == null) {
      Fluttertoast.showToast(msg: 'Image must not be empty');
      return;
    }
    pro.show();
    Firestore firestore = Firestore.instance;
    String autoId = firestore.collection('Users').document().documentID;
    final storage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image/$userId/image');
    StorageUploadTask uploadTask = storage.putFile(_pickedImage);
    // final downloadImageUrl = (await uploadTask.onComplete).ref.getDownloadURL();
    // var imageUrl = downloadImageUrl.toString();
    try {
      var dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
      imageUrl = dowurl.toString();
      print('DownloadUrl: $imageUrl');
    } catch (error) {
      print(error);
    }

    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    UserProfile userProfile = UserProfile(
        fullName: fullName,
        profileName: profileName,
        occupation: occupation,
        hobby: hobby,
        aToken: [tokenString],
        userId: userId,
        picUrl: imageUrl);

    try {
      await firestore
          .collection('users')
          .document(userId)
          .setData(userProfile.toJson(userProfile))
          .then((result) async {
        print('Data Saved');
        _sharedPreferences = await SharedPreferences.getInstance();
        _sharedPreferences.setString('id', userId);
        _sharedPreferences.setString('profileName', profileName);
        _sharedPreferences.setString('fullName', fullName);
        _sharedPreferences.setString('profileImage', imageUrl);
        pro.hide();
        Fluttertoast.showToast(
            msg: 'Your profile has been created successfully');
        Navigator.of(context).pushNamed('your_chat_home_screen');
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF24D39D),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            children: <Widget>[
              Container(
                height: height * 0.42,
                width: width,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    _pickedImage == null
                        ? Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                                height: 150,
                                width: 150,
                                child: Image.asset(
                                  'assets/use_profile_avatar_male_image.png',
                                  fit: BoxFit.cover,
                                )),
                          )
                        : Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            child: CircleAvatar(
                              radius: 80,
                              backgroundImage: FileImage(
                                _pickedImage,
                              ),
                            )),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Color(0xFF039be5),
                      onPressed: _showOptionsDialog,
                      child: Text(
                        'Select Image',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(60),
                          topRight: Radius.circular(60))),
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: height * 0.45,
                        child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 40,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: TextFormField(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your full name',
                                      ),
                                      // validator: (value) {
                                      //   String errorMessage;
                                      //   if (value.isEmpty || !value.contains('@')) {
                                      //     errorMessage = 'Invaid email !';
                                      //   }
                                      //   return errorMessage;
                                      // },
                                      onSaved: (value) {
                                        fullName = value;
                                      },
                                      validator: (value) {
                                        String errorMessage;
                                        if (value.isEmpty) {
                                          errorMessage =
                                              'Please enter your fullname';
                                        }
                                        return errorMessage;
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your profile name'),
                                    validator: (value) {
                                      String errorMessage;
                                      if (value.isEmpty) {
                                        errorMessage =
                                            'Plese enter your profile name';
                                      }
                                      return errorMessage;
                                    },
                                    onSaved: (value) {
                                      profileName = value;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your Occupation'),
                                    validator: (value) {
                                      String errorMessage;
                                      if (value.isEmpty) {
                                        errorMessage =
                                            'Plese enter your occupation';
                                      }
                                      return errorMessage;
                                    },
                                    onSaved: (value) {
                                      occupation = value;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                    top: 15,
                                    bottom: 15,
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                        hintText: 'Enter your hobby'),
                                    validator: (value) {
                                      String errorMessage;
                                      if (value.isEmpty) {
                                        errorMessage =
                                            'Please enter your hobby';
                                      }
                                      return errorMessage;
                                    },
                                    onSaved: (value) {
                                      hobby = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RaisedButton(
                        color: Color(0xFF24D39D),
                        onPressed: () {
                          pro.show();
                          _submit();
                        },
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showToast(String s) {
    Fluttertoast.showToast(
        msg: s,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0);
  }
}
