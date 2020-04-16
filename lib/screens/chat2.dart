// import 'dart:js';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:async';
// import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:your_chat_flutter_app/screens/chat.dart';

final containerColor = Color(0xFF112734);
final backgroundColor = Color(0xFF283F4D);

class YourChatChat extends StatelessWidget {
  final String inputMessage = '';
  // static const routeName = 'your_chat_chat_screen';

  final String peerProfieImagUrl;
  final String peerId;
  final String peerProfileName;

  YourChatChat({this.peerProfieImagUrl, this.peerId, this.peerProfileName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          peerProfileName,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_horiz),
            onPressed: () {},
          )
        ],
      ),
      body: YourChatChatScreen(
        peerId: peerId,
        peerProfileImageUrl: peerProfieImagUrl,
        peerProfileName: peerProfileName,
      ),
    );
  }
}

class YourChatChatScreen extends StatefulWidget {
  final String peerId;
  final String peerProfileImageUrl;
  final String peerProfileName;

  YourChatChatScreen(
      {@required this.peerId,
      @required this.peerProfileImageUrl,
      @required this.peerProfileName});
  @override
  _YourChatChatScreenState createState() => _YourChatChatScreenState(
      peerId: peerId,
      peerProfileImageUrl: peerProfileImageUrl,
      peerProfileName: peerProfileName);
}

class _YourChatChatScreenState extends State<YourChatChatScreen> {
  String peerId;
  String currentUserId;
  String peerProfileName;
  String peerProfileImageUrl;
  String groupChatId;
  var listMessage;
  String inputMessage;
  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  SharedPreferences _sharedPreferences;
  _YourChatChatScreenState(
      {@required this.peerId,
      @required this.peerProfileImageUrl,
      @required this.peerProfileName});

  @override
  void initState() {
    super.initState();

    readDataFromLocalStorage();
  }

  readDataFromLocalStorage() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    currentUserId = _sharedPreferences.getString('id') ?? '';
    if (currentUserId.hashCode <= peerId.hashCode) {
      groupChatId = '$currentUserId - $peerId';
    } else {
      groupChatId = '$peerId - $currentUserId';
    }
  }

  onMessageSend(String message) {
    if (message.trim() != '') {
      textEditingController.clear();
      var documentReference = Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(documentReference, {
          'idFrom': currentUserId,
          'idTo': peerId,
          'message': message,
          'timeStamp': DateTime.now().millisecondsSinceEpoch.toString(),
        });
      });
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send');
    }
  }

  // void getMessageStream<QuerySnapshot>() async {
  //   listMessage = await Firestore.instance
  //       .collection('messages')
  //       .document(groupChatId)
  //       .collection(groupChatId)
  //       .snapshots();

  //       for(var message in listMessage.docum)
  // }
  _buildSendMessage() {
    // String message;
    return Container(
      height: 70,
      color: containerColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // IconButton(
              //   icon: Icon(Icons.photo_library),
              //   color: Colors.white54,
              //   iconSize: 25,
              //   onPressed: () {},
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: TextField(
                    // onSubmitted: (value) {
                    //   inputMessage = value;
                    // },
                    controller: textEditingController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Send your Message',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white24,
                          letterSpacing: 1.2,
                        )),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                color: Colors.white54,
                iconSize: 25,
                onPressed: () {
                  print('messsag: ${textEditingController.text.toString()}');
                  onMessageSend(textEditingController.text.toString());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget buildItem(int index, DocumentSnapshot documentSnapshot) {
  //   if (documentSnapshot['idFrom'] == currentUserId) {
  //     return Row(
  //       children: <Widget>[
  //         Container(
  //             child: Text(
  //               documentSnapshot['message'],
  //               style: TextStyle(color: Colors.white),
  //             ),
  //             decoration: BoxDecoration(
  //                 color: backgroundColor.withOpacity(0.5),
  //                 borderRadius: BorderRadius.only(
  //                     bottomRight: Radius.circular(10),
  //                     bottomLeft: Radius.circular(10),
  //                     topLeft: Radius.circular(10))))
  //       ],
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('messages')
                .document(groupChatId)
                .collection(groupChatId)
                .snapshots(),
            // initialData: null,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.none) {
                  return Text('none');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Text('waiting');
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  return Text('none');
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text('done');
                }
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white70,
                  ),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Text('done');
                }
                // if (snapshot.connectionState == ConnectionState.active) {
                //   return Text('active');
                // }
                return Expanded(
                  child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        var lists = snapshot.data.documents.reversed.toList();
                        return ChatItem(
                          peerProfileImageUrl: peerProfileImageUrl,
                          peerProfileName: peerProfileName,
                          currentUserProfileName:
                              _sharedPreferences.getString('profileName') ?? '',
                          currentUserImageUrl:
                              _sharedPreferences.getString('profileImage') ??
                                  '',
                          message: lists[index]['message'],
                          sendingTime: lists[index]['timeStamp'],
                          idFrom: lists[index]['idFrom'],
                          idTo: lists[index]['idTo'],
                          currentUserId: currentUserId,
                        );
                      }),
                );
              }
            },
          ),
          _buildSendMessage()
        ],
      ),
    );

    // return Column(
    //   children: <Widget>[
    //     Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             color: containerColor,
    //             borderRadius: BorderRadius.only(
    //                 topRight: Radius.circular(30),
    //                 topLeft: Radius.circular(30))),
    //         child: Column(
    //           children: <Widget>[
    //             SizedBox(
    //               height: 20,
    //             ),
    //             Center(
    //               child: CircleAvatar(
    //                 radius: 40,
    //                 backgroundImage: NetworkImage(
    //                   peerProfileImageUrl,
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(top: 12),
    //               child: Center(
    //                 child: Text(
    //                   peerProfileName,
    //                   style: TextStyle(
    //                       fontSize: 28,
    //                       fontWeight: FontWeight.bold,
    //                       color: Colors.white),
    //                 ),
    //               ),
    //             )
    //             ,
    //             SizedBox(height: 20,)

    //             Stream
    //           ],
    //         ),
    //       ),
    //     )
    //   ],
    // );
  }
}

class ChatItem extends StatelessWidget {
  final String peerProfileImageUrl;
  final String currentUserImageUrl;
  final String peerProfileName;
  final String currentUserProfileName;
  final String message;
  final String sendingTime;
  final String idFrom;
  final String idTo;
  final String currentUserId;

  ChatItem({
    this.peerProfileName,
    this.peerProfileImageUrl,
    this.currentUserImageUrl,
    this.currentUserProfileName,
    this.message,
    this.sendingTime,
    this.idFrom,
    this.idTo,
    this.currentUserId,
  });
  @override
  Widget build(BuildContext context) {
    final isMe = currentUserId == idFrom;
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    isMe ? currentUserImageUrl : peerProfileImageUrl),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    isMe ? currentUserProfileName : peerProfileName,
                    style: TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    elevation: 6,
                    color:
                        isMe ? containerColor.withOpacity(0.8) : Colors.white54,
                    borderRadius: isMe
                        ? BorderRadius.only(
                            // topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))
                        : BorderRadius.only(
                            topRight: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                // Material(
                //   elevation: 6,
                //   child:
                //    Container(
                //     decoration: BoxDecoration(
                //         color: isMe
                //             ? backgroundColor.withOpacity(0.5)
                //             : backgroundColor.withOpacity(0.3),
                //         borderRadius: isMe
                //             ? BorderRadius.only(
                //                 topRight: Radius.circular(30),
                //                 bottomLeft: Radius.circular(30),
                //                 bottomRight: Radius.circular(30))
                //             : BorderRadius.only(
                //                 topRight: Radius.circular(30),
                //                 bottomRight: Radius.circular(30),
                //                 bottomLeft: Radius.circular(30))),
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Text(
                //         message,
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        DateFormat('dd MMM kk:mm').format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(sendingTime))),
                        style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12.0,
                            fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                // Text(isMe.toString())
              ],
            )
          ],
        ),
      ],
    );
  }
}
