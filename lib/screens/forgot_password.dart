import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<bool> doesEmailExist(String email) async {
    try {
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return true; // Email exists
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return false; // Email does not exist
      }
      throw e; // Other error
    }
  }

  Future<void> resetpassword() async {
    final email = emailController.text;

    try {
      print("Checking if email exists...");
      if (await doesEmailExist(email)) {
        print("Email exists. Sending password reset email...");
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Check your email to reset password"),
              );
            });
      } else {
        print("Email does not exist.");
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text("The provided email does not exist."),
            );
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: $e");
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email Address'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textInputAction: TextInputAction.done,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Enter a valid email'
                        : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: resetpassword,
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
