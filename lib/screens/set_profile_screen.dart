import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:your_chat_flutter_app/models/user_profile_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:progress_dialog/progress_dialog.dart';

class SetProfileScreen extends StatefulWidget {
  static const routeName = 'set_profile_screen';

  @override
  _SetProfileScreenState createState() => _SetProfileScreenState();
}

class _SetProfileScreenState extends State<SetProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  File _pickedImage;
  String fullName;
  String profileName;
  String occupation;
  String hobby;
  String tokenString;
  String userId;

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

  Future<void> _pickImageFromGallery() async {
    final image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 150, maxWidth: 150);
    setState(() {
      _pickedImage = image;
    });
    Navigator.of(context).pop();
  }

  Future<void> _pickImageFromCamera() async {
    final image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _pickedImage = image;
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
    Firestore firestore = Firestore.instance;
    String autoId = firestore.collection('Users').document().documentID;
    final storage = FirebaseStorage.instance
        .ref()
        .child('user_profile_image/$autoId/image');
    StorageUploadTask uploadTask = storage.putFile(_pickedImage);
    final downloadUrl =
        (await uploadTask.onComplete).ref.getDownloadURL().toString();
    print('DownloadUrl: $downloadUrl');
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

    _firebaseMessaging.getToken().then((token) {
      final tokenStr = token.toString();
      tokenString = token;
      print("Token: " + tokenString);
    });
    final _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    final uId = user.uid;
    userId = uId;

    UserProfile userProfile = UserProfile(
        fullName: fullName,
        profileName: profileName,
        occupation: occupation,
        hobby: hobby,
        aToken: [tokenString],
        userId: userId);

    firestore
        .collection('users')
        .document(userId)
        .setData(userProfile.toJson(userProfile))
        .then((result) {
      print('Data Saved');
      Fluttertoast.showToast(msg: 'Your profile has been created successfully');
    });

    Fluttertoast.showToast(
      msg: 'Form validate',
      toastLength: Toast.LENGTH_SHORT,
    );
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
                            child: Image.file(
                              _pickedImage,
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
                        onPressed: _submit,
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
}
