import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tett/screens/Login.dart';
import 'package:tett/themes/dark_theme.dart';
import 'package:tett/themes/light_theme.dart';
import 'package:tett/themes/theme_provider.dart';
import 'firebase_options.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), 
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawsMatch',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      
      //lightTheme,
      //darkTheme: darkTheme,//ThemeData(
      //  primaryColor: Color(0xFFFD6456),
      // ),
      home:const Login(),
    );
  }
}
