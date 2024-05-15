import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tett/firebase/fetch_data.dart';
import 'package:image_picker/image_picker.dart';

//import 'dart:js_interop_unsafe';


class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final currentuser = FirebaseAuth.instance.currentUser!;

  final petNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final petGendreController = TextEditingController();
  final typeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCategory;
List<String> categories = ['Cats', 'Dogs', 'Others'];
String? selectedPetGender;
List<String> petGenders = ['Male', 'Female'];
XFile? file;
String imageUrl = '';
  bool isUploading = false;
  
Future<void> _pickImageFromCamera() async {
  ImagePicker imagePicker = ImagePicker();
  file = await imagePicker.pickImage(source: ImageSource.camera);

  if (file == null) return;

  // Import dart:core
  String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
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
  Reference referenceRoot = FirebaseStorage.instance.ref();
  Reference referenceDirImages = referenceRoot.child('images');
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

  late CollectionReference dbRef;
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseFirestore.instance.collection('Animals');
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add your pet'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Start looking for your pet soulmate🐾',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          children: [
                            IconButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                _pickImageFromCamera();
                              },
                              icon: Icon(
                                color: Theme.of(context).colorScheme.primary,
                                Icons.camera_alt,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Take a picture",
                              selectionColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          children: [
                            IconButton(
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () async {
                                _pickImageFromGallery();
                              },
                              icon: Icon(
                                Icons.photo_library,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Upload from gallery",
                              selectionColor:
                                  Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox( height: 50,),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (file != null) ...[
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: FileImage(File(file!.path)),
                            ),
                           
                          ],
                          if (isUploading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 10),
                    ],
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      controller: petNameController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pet Name',
                        iconColor: Color.fromARGB(255, 82, 80, 80),
                      ),
                      validator: (petNameController) {
                        if (petNameController == null ||
                            petNameController.isEmpty) {
                          return 'Pet Name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: userAgeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Age',
                      ),
                      validator: (userAgeController) {
                        if (userAgeController == null ||
                            userAgeController.isEmpty) {
                          return 'Pet Age is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: breedController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Breed',
                      ),
                      validator: (breedController) {
                        if (breedController == null ||
                            breedController.isEmpty) {
                          return 'Pet Breed is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: colorController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'color',
                      ),
                      validator: (colorController) {
                        if (colorController == null ||
                            colorController.isEmpty) {
                          return 'color is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedPetGender,
                      onChanged: (newValue) {
                        setState(() {
                          selectedPetGender = newValue!;
                          petGendreController.text = newValue;
                        });
                      },
                      items: petGenders
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Pet Gender',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pet Gender is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue!;
                          typeController.text = newValue;
                        });
                      },
                      items: categories
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Category',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pet Category is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: locationController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'location',
                      ),
                      validator: (locationController) {
                        if (locationController == null ||
                            locationController.isEmpty) {
                          return 'Pet location is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Description',
                      ),
                      validator: (descriptionController) {
                        if (descriptionController == null ||
                            descriptionController.isEmpty) {
                          return 'Pet Description is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    MaterialButton(
                      onPressed: () async {
                        // Validate the form before submitting
                        if (_formKey.currentState?.validate() ?? false) {
                          Map<String, dynamic> animals = {
                            'pet_name': petNameController.text,
                            'age': userAgeController.text,
                            'breed': breedController.text,
                            'color': colorController.text,
                            'gender': petGendreController.text,
                            'category': typeController.text,
                            'location': locationController.text,
                            'description': descriptionController.text,
                            'image': imageUrl,
                            'email': currentuser.email,
                            'likes': [],
                          };
                          try {
                            await dbRef.add(animals);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FetchData(),
                              ),
                            );
                          } catch (e) {
                            print(e);
                          }
                        }
                      },
                      child: const Text('Insert Data'),
                      color: Color(0xFFFD6456),
                      textColor: Colors.white,
                      minWidth: 300,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}