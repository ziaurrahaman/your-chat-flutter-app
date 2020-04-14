import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:your_chat_flutter_app/screens/chat2.dart';

class UserListItme extends StatelessWidget {
  final String imageUrl;
  final String fullName;
  final String profileName;
  // final int index;
  final String id;
  // final DocumentSnapshot document;
  UserListItme(
      {this.imageUrl,
      this.fullName,
      this.profileName,
      // this.index,
      // this.document,
      this.id});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YourChatChat(
                      peerId: id,
                      peerProfieImagUrl: imageUrl,
                      peerProfileName: profileName,
                    )));
      },
      child: ListTile(
        leading:
            CircleAvatar(radius: 30, backgroundImage: NetworkImage(imageUrl)),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(fullName),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(profileName),
        ),
      ),
    );
  }
}
