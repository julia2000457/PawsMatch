import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tett/models/chat_page.dart';
import 'package:tett/models/comment_button.dart';
import 'package:tett/models/comments.dart';
import 'package:tett/models/date.dart';
import 'package:tett/models/like_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AdoptPetScreen extends StatefulWidget {
  final documentId;
  final users;
  final List<String> likes;
  int currentIndex = 0;
  int piccurrentIndex = 0;
  late GoogleMapController mapController;

  AdoptPetScreen(this.documentId, this.users, this.likes, {Key? key})
      : super(key: key);

  @override
  _AdoptPetScreenState createState() => _AdoptPetScreenState();
}

class _AdoptPetScreenState extends State<AdoptPetScreen> {
  //user
  final currentuser = FirebaseAuth.instance.currentUser!;
  bool isliked = false;

  //comment text controller
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isliked = widget.likes.contains(currentuser.email);
  }

  void toggleLike() {
    setState(() {
      isliked = !isliked;
    });

    //Acsses in firebase
    DocumentReference postRef =
        FirebaseFirestore.instance.collection('Animals').doc(widget.documentId);

    if (isliked) {
      //if the post is liked add user email to the likes field
      postRef.update({
        'likes': FieldValue.arrayUnion([currentuser.email])
      });
    } else {
      //if unliked remove email
      postRef.update({
        'likes': FieldValue.arrayRemove([currentuser.email])
      });
    }
  }
//add a comment

  void addcomment(String commentText) {
    // write comment to firesore under comments collection for this pet
    FirebaseFirestore.instance
        .collection('Animals')
        .doc(widget.documentId)
        .collection("Comments")
        .add({
      "CommentedText": commentText,
      "CommentedBy": currentuser.email,
      "CommentTime": Timestamp.now(),
    });
  }

//show dialog box for adding comment
  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add comment"),
        content: TextField(
          controller: _commentTextController,
          decoration: const InputDecoration(hintText: "Write a comment..."),
        ),
        actions: [
//save button
          TextButton(
            onPressed: () {
              addcomment(_commentTextController.text);

              _commentTextController.clear();

              Navigator.pop(context);
            },
            child: const Text("Post"),
          ),

//cancle button
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancle"),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String label, String info) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      width: 100.0,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 243, 208, 208),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            info,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 115, 94, 94),
            ),
          ),
        ],
      ),
    );
  }

  CollectionReference pets = FirebaseFirestore.instance.collection('Animals');
  Future<void> _openGoogleMaps(String location) async {
    final Uri googleMapsUrl =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$location');
    if (!await launchUrl(googleMapsUrl)) {
      print('Could not open Google Maps.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pet Details',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: pets.doc(widget.documentId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Hero(
                          tag: widget.documentId,
                          child: Container(
                            width: double.infinity,
                            height: 300.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(data["image"] ?? ""),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            data['pet_name'],
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  LikeButton(
                                    onTap: toggleLike,
                                    isLiked: isliked,
                                  ),
                                  const SizedBox(height: 5),

                                  //like count
                                  Text(widget.likes.length.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: Text(
                        data['breed'],
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          color: Theme.of(context)
                              .colorScheme
                              .primary, // Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 30.0),
                      height: 120.0,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          const SizedBox(width: 30.0),
                          _buildInfoCard('Age', data['age'].toString()),
                          _buildInfoCard('Sex', data['gender']),
                          _buildInfoCard('Color', data['color']),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 25.0),
                      child: Text(
                        data['description'],
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontFamily: 'Montserrat',
                          fontSize: 15.0,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: CommentButton(
                            onTap: () => showCommentDialog(),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Animals")
                          .doc(widget.documentId)
                          .collection("Comments")
                          .orderBy("CommentTime", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ListView(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          children: snapshot.data!.docs.map((doc) {
                            final commentData =
                                doc.data() as Map<String, dynamic>;
                            return Comment(
                              text: commentData["CommentedText"],
                              user: commentData["CommentedBy"],
                              time: formatDate(commentData["CommentTime"]),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40.0, 0.0, 40.0, 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Chatpage(
                                    receiverEmail: data['email'],
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20.0),
                              primary: Color(0xFFFD6456),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            icon: const Icon(
                              Icons.pets,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'connect',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_location,
                              color: Color.fromARGB(255, 248, 108, 96),
                              size: 40.0,
                            ),
                            onPressed: () {
                              String loc = data['location'];
                              _openGoogleMaps(loc);
                              print('the location is in ${data['location']}');
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
