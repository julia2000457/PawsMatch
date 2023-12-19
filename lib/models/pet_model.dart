import 'package:flutter_pet_adoption_ui/models/owner_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pet_adoption_ui/screens/user_details.dart';

class Pet {
  final Owner owner;
  final String name;
  final String imageUrl;
  final String description;
  final int age;
  final String sex;
  final String color;
  final int id;

  Pet({
    required this.owner,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.age,
    required this.sex,
    required this.color,
    required this.id,
  });
}

class PetOwner {
  final String name;
  final String profilePicUrl;
  final String location;
  final String email;
  final String phone;

  PetOwner({
    required this.name,
    required this.profilePicUrl,
    required this.location,
    required this.email,
    required this.phone,
  });
}

var owner = Owner(
    name: 'User',
    imageUrl: 'assets/images/user.png',
    bio:
        'A 2 year old female Cocker Spaniel looking for a male dog from the same breed.I would love to host the male dog at my home, and I will be responsible for feeding and taking care of him same as Wezy during his stay,would also appreciate if you can mention what type of food he preferes🥰');
var pets = [
  Pet(
    owner: owner,
    name: 'Wezy',
    imageUrl: 'assets/images/wezy.jpg',
    description: 'Cocker Spaniel',
    age: 2,
    sex: 'Female',
    color: 'Golden',
    id: 12345,
  ),
  Pet(
    owner: owner,
    name: 'Bruno',
    imageUrl: 'assets/images/pug.jpg',
    description: 'Cavapoo',
    age: 1,
    sex: 'Female',
    color: 'Black',
    id: 98765,
  ),
];
void main() {
  PetOwner petOwner = PetOwner(
    name: 'Julia Doe',
    profilePicUrl: 'assets/images/ana.jpg', // Replace with the actual URL
    location: 'Al Rehab, Egypt',
    email: 'julia.doe@example.com',
    phone: '01204186861',
  );

  runApp(
    MaterialApp(
      home: PetOwnerProfilePage(petOwner: petOwner),
      debugShowCheckedModeBanner: false,
    ),
  );
}
