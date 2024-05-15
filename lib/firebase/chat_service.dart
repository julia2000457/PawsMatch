import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tett/models/Message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream


  Stream<List<Map<String, dynamic>>> getUserStream() {
  return _firestore.collection('Animals').snapshots().map((snapshot) {
    Set<String> uniqueEmails = Set<String>();
    List<Map<String, dynamic>> uniqueUsers = [];

    snapshot.docs.forEach((doc) {
      final email = doc['email'] as String?;
      if (email != null && uniqueEmails.add(email)) {
        uniqueUsers.add(doc.data() as Map<String, dynamic>);
      }
    });

    return uniqueUsers;
  });
}

//   Stream<List<String>> getUserStream() {
//   return _firestore.collection('Animals').snapshots().map((snapshot) {
//     // Use a Set to ensure unique emails
//     Set<String> uniqueEmails = Set<String>();

//     snapshot.docs.forEach((doc) {
//       final email = doc['email'] as String?;
//       // Check if the email is not null and add it to the set
//       if (email != null) {
//         uniqueEmails.add(email);
//       }
//     });

//     // Convert the set to a list
//     List<String> uniqueEmailsList = uniqueEmails.toList();
    
//     return uniqueEmailsList;
//   });
// }



// send a message
  Future<void> sendMessage(String receiverEmail, String message) async {
// get curent user info
    //final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

// create a new message
    Message newMessage = Message(
        //senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp);

//construct chat room Id  for the 2 users (sorted )

    List<String> ids = [currentUserEmail, receiverEmail];
    ids.sort(); // ensure chatroomid is the same for any 2 people
    String chatroomID = ids.join('_');

// add new message to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

//get message

  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    //construct a chatroom id for 2 users
    List<String> ids = [userEmail, otherUserEmail];
    ids.sort();
    String chatroomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
