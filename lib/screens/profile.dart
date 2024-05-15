import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tett/screens/pet_pofile.dart';
import 'package:tett/screens/text_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String imageUrl = "";
  final currentuser = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit $field",
          style: const TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(newValue);
              if (newValue.trim().length > 0) {
                await usersCollection
                    .doc(currentuser.email)
                    .update({field: newValue});
              }
            },
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  XFile? file;

  Future<void> _pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    Reference referenceImageToUpload =
        FirebaseStorage.instance.ref().child('profile_images/${currentuser.uid}');
    try {
      await referenceImageToUpload.putFile(File(file!.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        file = file;
        imageUrl = imageUrl;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyProfile"),
        backgroundColor: const Color.fromARGB(255, 99, 99, 99),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(currentuser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;
            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Animals")
                  .where("email", isEqualTo: currentuser.email)
                  .snapshots(),
              builder: (context, petsnapshot) {
                if (petsnapshot.hasData) {
                  final petDataList = petsnapshot.data!.docs;

                  return ListView(
                    children: [
                      const SizedBox(height: 50),
                      IconButton(
                        onPressed: () async {
                          ImagePicker imagePicker = ImagePicker();
                          file = await imagePicker.pickImage(
                              source: ImageSource.camera);

                          if (file == null) return;

                          Reference referenceImageToUpload =
                              FirebaseStorage.instance.refFromURL(userData['image']);
                          try {
                            await referenceImageToUpload
                                .putFile(File(file!.path));
                            imageUrl = await referenceImageToUpload
                                .getDownloadURL();
                          } catch (error) {
                            print(error);
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.toString())));
                          }
                        },
                        icon: Icon(Icons.edit),
                      ),
                      CircleAvatar(
                        radius: 100,
                        backgroundColor: Color.fromARGB(0, 183, 177, 177),
                        child: ClipOval(
                          child: Image.network(
                            userData["image"] ?? "",
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        currentuser.email!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "My Details",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      MyTextBox(
                        SectionName: "First Name",
                        text: userData["First name"],
                        onPressed: () => editField('First name'),
                      ),
                      MyTextBox(
                        SectionName: "Last Name",
                        text: userData["Last name"],
                        onPressed: () => editField('Last name'),
                      ),
                      MyTextBox(
                        SectionName: "Gender",
                        text: userData["Gender"],
                        onPressed: () => editField('Gender'),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "My Pets",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      for (var petData in petDataList)
                        MyTextBox(
                          SectionName: "Pet Name",
                          text: petData['pet_name'],
                          onPressed: () {
                            print('this is pet id ${petData.id}');
                            var documentId = petData.id;
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) =>
                                    PetProfileScreen(documentid: documentId),
                              ),
                            );
                          },
                        ),
                    ],
                  );
                } else if (petsnapshot.hasError) {
                  return Center(
                    child: Text('Error fetching pets data'),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error fetching user data'),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
