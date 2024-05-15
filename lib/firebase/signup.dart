import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tett/screens/Login.dart';



class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
      String? selectedGender;
List<String> Genders = ['Male', 'Female'];

  String imageUrl = '';
  CollectionReference _reference =
      FirebaseFirestore.instance.collection('users');
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
      String errorMessage = "Error during signup. Please fill the form";

      switch (e.code) {
        case "email-already-in-use":
          errorMessage = "The email address is already in use.";
          break;
        case "invalid-email":
          errorMessage = "Invalid email address.";
          break;
        case "weak-password":
          errorMessage =
              "The password is too weak. The password should be 6 characters minimum";
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 5),
        ),
      );
    }
    return user;
  }

  bool isUploading = false;

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
      setState(() {
        isUploading = true;
      });
      // Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        // Update the state variables
        file = file;
        imageUrl = imageUrl;
        isUploading = false;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        isUploading = false;
      });
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
      setState(() {
        isUploading = true;
      });
      // Store the file
      await referenceImageToUpload.putFile(File(file!.path));
      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();

      setState(() {
        // Update the state variables
        file = file;
        imageUrl = imageUrl;
        isUploading = false;
      });
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
      setState(() {
        isUploading = false;
      });
    }
  }

  void signin() async {
    try {
      if (file == null) {
        // No picture uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please upload a profile picture."),
            duration: Duration(seconds: 5),
          ),
        );
        return;
      }
      if (confirmPasswordController.text == passwordController.text) {
        User? user = await createUserWithEmailAndPassword(
          emailController.text,
          passwordController.text,
          firstNameController.text,
          lastNameController.text,
          genderController.text,
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password mismatch"),
            duration: Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      print("Error during signup: $e");

      // Handle specific error cases or show a general error message to the user
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup failed: ${e}. Please try again."),
          duration: const Duration(seconds: 10),
        ),
      );
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
                      padding: const EdgeInsets.fromLTRB(15, 110, 0, 0),
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          color: Color(0xFFFD6456),
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
                    if (isUploading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
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
                        icon: const Icon(
                          Icons.camera_alt,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Take a picture"),
                    ],
                  ),
                  const SizedBox(width: 40),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _pickImageFromGallery();
                        },
                        icon: const Icon(
                          Icons.photo_library,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text("Upload from gallery"),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.only(top: 35, left: 20, right: 30),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 50.0),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: firstNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'First name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: lastNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Last name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: DropdownButtonFormField<String>(
                        value: selectedGender,
                        onChanged: (newValue) {
                          setState(() {
                            selectedGender = newValue!;
                          });
                        },
                        items: Genders.map<DropdownMenuItem<String>>(
                            (String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Gender',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        obscureText: true,
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
                        onPressed: signin,
                        child: const Text(
                          'Signup',
                          style: TextStyle(color: Colors.white),
                        ),
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
                          child: const Text(
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
