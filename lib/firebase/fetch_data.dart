//import 'dart:js_interop_unsafe';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tett/firebase/pet_details.dart';
import 'package:tett/models/delete_button.dart';

import 'package:tett/screens/adopt_pet_screen.dart';
import 'package:tett/screens/chats.dart';
import 'package:tett/screens/drawer.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  final currentuser = FirebaseAuth.instance.currentUser!;

  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('Animals');
  Map<String, dynamic>? _deletedPet;

  //DocumentSnapshot documentSnapshot = CollectionReference.doc('Animals').get();

  var allisSelected = false;
  var dogisSelected = false;
  var catisSelected = false;
  var otherisSelected = false;
  var pettype = 'All';

  Widget listItem({required Map<String, dynamic> animals}) {
    return Container(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdoptPetScreen(
                      animals['key'],
                      animals['email'],
                      List<String>.from(animals['likes'] ?? [])),
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(left: 40.0, bottom: 30.0, right: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Hero(
                    tag: animals.keys,
                    child: Container(
                      width: double.infinity,
                      height: 250.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          topLeft: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                        image: DecorationImage(
                          image: NetworkImage(animals["image"] ?? ""),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 12.0, 40.0, 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          animals['pet_name'],
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(115, 120, 114, 0.702),
                          ),
                        ),
                        //delete button
                        if (animals['email'] == currentuser.email)
                          DeleteButton(onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete Post",
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 95, 93, 93))),
                                content: const Text(
                                  "Are you sure you want to delete this post?",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 95, 93, 93)),
                                ),
                                actions: [
                                  // cancle button
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancle "),
                                  ),

                                  TextButton(
                                    onPressed: () async {
                                      // Save the deleted pet before deletion
                                      DocumentSnapshot<Map<String, dynamic>>
                                          snapshot =
                                          await dbRef.doc(animals['key']).get();

                                      if (snapshot.exists) {
                                        _deletedPet = Map<String, dynamic>.from(
                                            snapshot.data() ?? {});
                                        _deletedPet!['key'] = animals['key'];
                                        // delete comments
                                        final commentDocs =
                                            await FirebaseFirestore.instance
                                                .collection("Animals")
                                                .doc(animals['key'])
                                                .collection("Comments")
                                                .get();

                                        for (var doc in commentDocs.docs) {
                                          await FirebaseFirestore.instance
                                              .collection("Animals")
                                              .doc(animals['key'])
                                              .collection("Comments")
                                              .doc(doc.id)
                                              .delete();
                                        }

                                        // delete pet

                                        FirebaseFirestore.instance
                                            .collection("Animals")
                                            .doc(animals['key'])
                                            .delete()
                                            .then(
                                                (value) => print("Pet Deleted"))
                                            .catchError((error) => print(
                                                "Failed to delete post $error"));

                                        // dismiss dialog box
                                        // ignore: use_build_context_synchronously
                                        Navigator.pop(context);
                                        // Show a Snackbar with Undo option
                                        // ignore: use_build_context_synchronously
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text("Pet deleted"),
                                            duration: Duration(seconds: 10),
                                            action: SnackBarAction(
                                              label: "Undo",
                                              onPressed: () async {
                                                // Restore the deleted pet
                                                await FirebaseFirestore.instance
                                                    .collection("Animals")
                                                    .doc(_deletedPet!['key'])
                                                    .set(_deletedPet!)
                                                    .then((value) =>
                                                        print("Pet Restored"))
                                                    .catchError((error) => print(
                                                        "Failed to restore pet $error"));
                                                _deletedPet = null;
                                              },
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: const Text("Delete"),
                                  ),

                                  // delete button
                                ],
                              ),
                            );
                          })
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.0, 0.0, 40.0, 12.0),
                    child: Text(
                      animals['breed'].toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget _buildPetCategory(bool isSelected, String category) {
    return GestureDetector(
      onTap: () {
        print('ah $category');

        switch (category) {
          case 'All':
            setState(() {
              pettype = "All";
              allisSelected = true;
              dogisSelected = false;
              catisSelected = false;
              otherisSelected = false;
            });

            break;
          case 'Cats':
            setState(() {
              pettype = 'Cats';
              allisSelected = false;
              dogisSelected = false;
              catisSelected = true;
              otherisSelected = false;
            });
            break;
          case 'Dogs':
            setState(() {
              pettype = 'Dogs';
              allisSelected = false;
              dogisSelected = true;
              catisSelected = false;
              otherisSelected = false;
            });
            break;
          case 'Other':
            setState(() {
              pettype = 'Others';
              allisSelected = false;
              dogisSelected = false;
              catisSelected = false;
              otherisSelected = true;
            });
            break;
          default:
        }
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: 80.0,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.tertiary
              : Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(
                  width: 8.0,
                  color: Color(0xFFFED8D3),
                )
              : null,
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
      ),
    );
  }

  Widget filter() {
    return Container(
      height: 100.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: 40.0),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.filter_alt),
          ),
          _buildPetCategory(allisSelected, 'All'),
          _buildPetCategory(dogisSelected, 'Dogs'),
          _buildPetCategory(catisSelected, 'Cats'),
          _buildPetCategory(otherisSelected, 'Other'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HOME 🐾',
          style: TextStyle(
            color: Color(0xFFFD6456),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      drawer: const drawer(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: filter(),
          ),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: pettype == "All"
                ? dbRef.snapshots()
                : dbRef.where('category', isEqualTo: pettype).snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot<Map<String, dynamic>>> documents =
                  snapshot.data?.docs ?? [];

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Map<String, dynamic> animals =
                        documents[index].data() ?? {};
                    animals['key'] = documents[index].id;
                    print('btdwr 3ala ${documents[index].get('category')}');
                    return listItem(animals: animals);
                  },
                  childCount: documents.length,
                ),
              );
            },
          ),
        ],
      ),
      persistentFooterButtons: [
        // Add your bottom navigation bar items here
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(
                Icons.add,
                size: 40,
              ),
              color: Color.fromARGB(255, 248, 108, 96),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InsertData(),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.chat,
                color: Color.fromARGB(255, 248, 108, 96),
                size: 40.0,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatMessages(),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
