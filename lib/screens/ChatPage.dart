// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_pet_adoption_ui/comp/ChatService.dart';
// import 'package:flutter_pet_adoption_ui/comp/Chat_Bubble.dart';

// class ChatPage extends StatefulWidget {
//   final String receiverUserEmail;
//   final String receiverUserID;

//   const ChatPage({
//     Key? key,
//     required this.receiverUserEmail,
//     required this.receiverUserID,
//   }) : super(key: key);

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ChatService _chatService = ChatService();
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(
//           widget.receiverUserID, _messageController.text);

//       _messageController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.receiverUserEmail)),
//       body: Column(
//         children: [
//           // Message List
//           Expanded(
//             child: _buildMessageList(),
//           ),

//           // User Input
//           _buildMessageInput(),

//           const SizedBox(height: 25),
//         ],
//       ),
//     );
//   }

//   // Build Message List
//   Widget _buildMessageList() {
//     return StreamBuilder(
//       stream: _chatService.getMessages(
//           widget.receiverUserID, _firebaseAuth.currentUser!.uid),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error ${snapshot.error}');
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text('Loading...');
//         }

//         return ListView(
//           children: snapshot.data!.docs
//               .map((document) => _buildMessageItem(document))
//               .toList(),
//         );
//       },
//     );
//   }

//   // Build Message Item
//   Widget _buildMessageItem(DocumentSnapshot document) {
//     Map<String, dynamic> data = document.data() as Map<String, dynamic>;

//     var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
//         ? Alignment.centerRight
//         : Alignment.centerLeft;

//     return Container(
//       alignment: alignment,
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           crossAxisAlignment:
//               (data['senderId'] == _firebaseAuth.currentUser!.uid)
//                   ? CrossAxisAlignment.end
//                   : CrossAxisAlignment.start,
//           mainAxisAlignment:
//               (data['senderId'] == _firebaseAuth.currentUser!.uid)
//                   ? MainAxisAlignment.end
//                   : MainAxisAlignment.start,
//           children: [
//             Text(data['senderName']),
//             const SizedBox(height: 5),
//             ChatBubble(message: data['message']),
//           ],
//         ),
//       ),
//     );
//   }

//   // Build Message Input
//   Widget _buildMessageInput() {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 25.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: MyTextField(
//               controller: _messageController,
//               hintText: 'Enter message',
//             ),
//           ),
//           IconButton(
//             onPressed: sendMessage,
//             icon: const Icon(
//               Icons.arrow_upward,
//               size: 40,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

// class MyTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;

//   const MyTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hintText,
//      ),
// );
// }
// }