import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tett/firebase/chat_service.dart';
import 'package:tett/models/chat_bubble.dart';

class Chatpage extends StatefulWidget {
  final String receiverEmail;
  //final String receiverID;

  Chatpage({
    super.key,
    required this.receiverEmail, //required this.receiverID
  });

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  // text controller
  final TextEditingController _messageController = TextEditingController();

  // chat and auth service
  final ChatService _chatService = ChatService();
  final currentuser = FirebaseAuth.instance.currentUser!;

  // for textfeild focus
  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // add listener to focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });

    Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.fastOutSlowIn,
    );
  }

  //final AuthService _authService = AuthService();
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //send
      await _chatService.sendMessage(
          widget.receiverEmail, _messageController.text);

      // clear after send
      _messageController.clear();
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
// display all message
          Expanded(
            child: _bulidMessageList(),
          ),

// display user input
          _buildUserInput()
        ],
      ),
    );
  }

  // build message list
  Widget _bulidMessageList() {
    String senderEmail = currentuser.email!;

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverEmail, senderEmail),
      builder: (context, snapshot) {
        // errors
        if (snapshot.hasError) {
          return const Text("Error");
        }

        // loading

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }
        // return list view
        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _bulidMessageItem(doc)).toList(),
        );
      },
    );
  }

  // build message item
  Widget _bulidMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // is current user
    bool isCurrentUser = data['senderEmail'] == currentuser.email!;

    // sender is current user align to right otherwise left
    var alignmnet =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignmnet,
      child: ChatBubble(
        message: data["message"],
        isCurrentUser: isCurrentUser,
      ),
    );
  }

  // build message input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                obscureText: false,
                controller: _messageController,
                focusNode: myFocusNode,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Type a message',
                ),
              ),
            ),
          ),

          // send icon
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFD6456),
              shape: BoxShape.circle,
            ),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.arrow_upward),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
