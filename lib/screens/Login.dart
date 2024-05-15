import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tett/firebase/fetch_data.dart';
import 'package:tett/screens/forgot_password.dart';
import 'package:tett/firebase/signup.dart';
import 'package:tett/themes/dark_theme.dart';
import 'package:tett/themes/theme_provider.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: Scaffold(
        body: const MyStatefulWidget(),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("No user found for that email");
      }
      print("Errror signing in $e");
    }
    return user;
  }

  void _showSnackBar() {
    const snackBar = SnackBar(
      content: Text('Your email or password is not correct'),
      duration: Duration(seconds: 10), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _emailController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();

    return Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 120.0),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: Text(
                'PawsMatch',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w500,
                    fontSize: 50),
              ),
            ),
            Icon(
              Icons.pets_sharp,
              size: 70.0,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            const SizedBox(height: 100.0),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextField(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                controller: _emailController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    floatingLabelStyle: TextStyle(color: Colors.black)),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextField(
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    floatingLabelStyle: TextStyle(color: Colors.black)),
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ForgotPassword()));
              },
              child: const Text(
                'Forgot Password',
              ),
            ),
            Container(
              height: 50,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () async {
                  User? user = await signInWithEmailAndPassword(
                      _emailController.text, _passwordController.text);
                  print(user);
                  if (user != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => FetchData()));
                  } else {
                    _showSnackBar();
                  }
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Does not have account?',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                TextButton(
                  child: Text(
                    'Sign Up',
                    style: const TextStyle(fontSize: 20),
                    selectionColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignupPage(),
                        ));
                  },
                )
              ],
            ),
          ],
        ));
  }
}
