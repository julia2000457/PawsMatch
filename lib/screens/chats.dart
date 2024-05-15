import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tett/firebase/chat_service.dart';
import 'package:tett/models/chat_page.dart';
import 'package:tett/models/user_tile.dart';
import 'package:tett/screens/drawer.dart';

class ChatMessages extends StatelessWidget {
  ChatMessages({super.key});

  // chat service
  final ChatService _chatService = ChatService();
  final currentuser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Chats"),
      ),
      //drawer: const drawer(),
      body: _buildUserList(),
    );
  }

  // build a list f users except the users loged in
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUserStream(),
      builder: (context, snapshot) {
        // error
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // return ist view
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // display al users except loged in
    if(userData['email'] != currentuser.email ){
      return UserTile(
      text: userData['email'],
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Chatpage(receiverEmail: userData["email"],),
          ),
        );
      },
    );
    } else {
      return Container();
    }
  }
}
