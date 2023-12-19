import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_adoption_ui/firebase/fetch_data.dart';

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {
  final petNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final breedController = TextEditingController();
  final colorController = TextEditingController();
  final petGendreController = TextEditingController();
  final typeController = TextEditingController();
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();

  late CollectionReference dbRef;
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseFirestore.instance.collection('Animals');
  }

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
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    'Start looking for your pet soulmate🐾',
                    style: TextStyle(
                      color: Color(0xFFFD6456),
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: petNameController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Pet Name',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: userAgeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Age',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: breedController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Breed',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: colorController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'color',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: petGendreController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'pet gender',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: typeController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'category',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: locationController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'location',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'description',
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Map<String, dynamic> animals = {
                        'pet_name': petNameController.text,
                        'age': userAgeController.text,
                        'breed': breedController.text,
                        'color': colorController.text,
                        'gender': petGendreController.text,
                        'category': typeController.text,
                        'location': locationController.text,
                        'description': descriptionController.text,
                      };
                      try {
                        await dbRef.add(animals);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FetchData(),
                            ));
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Insert Data'),
                    color: Colors.blue,
                    textColor: Colors.white,
                    minWidth: 300,
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
