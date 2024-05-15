import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tett/screens/Login.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String imageUrl = '';
  //final currentuser = FirebaseAuth.instance.currentUser;

  Future createUserWithEmailAndPassword(String email, String password,
      String firstname, String lastname, String gender, String img) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user = result.user;
      FirebaseFirestore.instance.collection("users").doc(user?.email).set({
        'First name': firstname,
        'Last name': lastname,
        'Gender': gender,
        'image': img,
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("no user found for that email");
      }
      print("Error signing in $e");
    }
    return user;
  }

  // Future addUserDetails(
  //     String firstname, String lastname, String gender, String imageUrl, String email) async {
  //   await FirebaseFirestore.instance.collection("users").add({
  //     'First name': firstname,
  //     'Last name': lastname,
  //     'Gender': gender,
  //     'image': imageUrl,
  //     'Email': email,
  //   });
  // }
// final userAuth = FirebaseAuth.instance.currentUser!;
//   Future setUserDetails(String firstname, String lastname, String gender, String imageUrl)async{
// await
//   }

  XFile? file;

  Future<void> _pickImageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: ImageSource.camera);

    if (file == null) return;

    // Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Step 2: Upload to Firebase storage
    // Install firebase_storage
    // Import the library

    // Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    // Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
      // Update the state variables
      file = file;
      imageUrl = imageUrl;
    });

    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }

  Future<void> _pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    file = await imagePicker.pickImage(source: ImageSource.gallery);

    if (file == null) return;

    // Import dart:core
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Step 2: Upload to Firebase storage
    // Install firebase_storage
    // Import the library

    // Get a reference to storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');

    // Create a reference for the image to be stored
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
      // Update the state variables
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
    // // Get a reference to storage root
    // Reference referenceRoot = FirebaseStorage.instance.ref();
    // Reference referenceDirImages = referenceRoot.child('images');

    // // Create a reference for the image to be stored
    // Reference referenceImageToUpload =
    //     referenceDirImages.child('uniqueFileName');

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 110, 0, 0),
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.w500,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (file != null) ...[
                      CircleAvatar(
                        radius: 100,
                        backgroundImage: FileImage(File(file!.path)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _pickImageFromCamera();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Take a picture"),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _pickImageFromGallery();
                        },
                        icon: Icon(
                          Icons.photo_library,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text("Upload from gallery"),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 35, left: 20, right: 30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50.0),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: _genderController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Gender',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confirm password',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Signup'),
                        onPressed: () async {
                          try {
                            if (_confirmPasswordController.text ==
                                _passwordController.text) {
                              User? user = await createUserWithEmailAndPassword(
                                _emailController.text,
                                _passwordController.text,
                                _firstNameController.text,
                                _lastNameController.text,
                                _genderController.text,
                                imageUrl,
                              );

                              if (user != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              }
                              print(user);
                            }
                          } catch (e) {
                            print("Error during signup: $e");
                            // Handle specific error cases or show a general error message to the user
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text("Signup failed. Please try again."),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Already have an account',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}