import 'package:flutter/material.dart';
import 'package:flutter_pet_adoption_ui/models/pet_model.dart';

class PetOwnerProfilePage extends StatelessWidget {
  final PetOwner petOwner;

  PetOwnerProfilePage({required this.petOwner});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 130),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(petOwner.profilePicUrl),
              ),
              SizedBox(height: 20),
              Text(
                petOwner.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Location: ${petOwner.location}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Email: ${petOwner.email}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Contact Number: ${petOwner.phone}',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
