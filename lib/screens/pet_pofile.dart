import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tett/screens/text_box.dart';

class PetProfileScreen extends StatefulWidget {
  final documentid;
  const PetProfileScreen({Key? key, required this.documentid}) : super(key: key);

  @override
  State<PetProfileScreen> createState() => _PetProfileScreenState();
}

class _PetProfileScreenState extends State<PetProfileScreen> {
  String imageUrl = "";
  final currentuser = FirebaseAuth.instance.currentUser!;
  final petCollection = FirebaseFirestore.instance.collection('Animals');
  Map<String, dynamic>? petData; // Declare petData as an instance variable
  XFile? file;

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
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (newValue.trim().length > 0) {
      await petCollection.doc(widget.documentid).update({field: newValue});
    }
  }

  Future<void> _pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null || petData == null || petData!['image'] == null) return;

    Reference referenceImageToUpload =
        FirebaseStorage.instance.refFromURL(petData!['image']);
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
        title: Text("Pet Profile"),
        backgroundColor: const Color.fromARGB(255, 99, 99, 99),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Animals")
            .doc(widget.documentid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            petData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 50),
                IconButton(
                  onPressed: () async {
                    ImagePicker imagePicker = ImagePicker();
                    file =
                        await imagePicker.pickImage(source: ImageSource.camera);

                    if (file == null || petData == null || petData!['image'] == null) return;

                    Reference referenceImageToUpload =
                        FirebaseStorage.instance.refFromURL(petData!['image']);
                    try {
                      await referenceImageToUpload.putFile(File(file!.path));
                      imageUrl = await referenceImageToUpload.getDownloadURL();
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
                      petData!["image"] ?? "",
                      fit: BoxFit.cover,
                      width: 200,
                      height: 200,
                    ),
                  ),
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
                  SectionName: "Pet Name",
                  text: petData!["pet_name"],
                  onPressed: () => editField('pet_name'),
                ),
                MyTextBox(
                  SectionName: "Age",
                  text: petData!["age"],
                  onPressed: () => editField('age'),
                ),
                MyTextBox(
                  SectionName: "Description",
                  text: petData!["description"],
                  onPressed: () => editField('description'),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching pet data'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
