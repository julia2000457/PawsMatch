
import 'package:cloud_firestore/cloud_firestore.dart';

class Message{

//final String senderID;
final String senderEmail;
final String receiverEmail;
final String message;
final Timestamp timestamp;


Message({
  //required this.senderID,
  required this.senderEmail,
  required this.receiverEmail,
  required this.message,
  required this.timestamp
});

// convert to map 

Map<String,dynamic> toMap(){
  return {

    //'senderID' : senderID,
    'senderEmail' : senderEmail,
    'receiverEmail' : receiverEmail,
    'message' : message,
    'timestamp' : timestamp,
  };
}
}