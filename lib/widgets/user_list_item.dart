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
        leading: CircleAvatar(
            radius: 30,
            backgroundImage: imageUrl == null
                ? NetworkImage(
                    'https://images.unsplash.com/photo-1526800544336-d04f0cbfd700?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1567&q=80')
                : NetworkImage(imageUrl)),
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
