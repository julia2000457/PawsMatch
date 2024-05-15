import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tett/firebase/fetch_data.dart';
import 'package:tett/models/my_list_tile.dart';
import 'package:tett/screens/Login.dart';
import 'package:tett/screens/profile.dart';
import 'package:tett/themes/theme_provider.dart';

class drawer extends StatefulWidget {
  const drawer({super.key});

  @override
  State<drawer> createState() => _drawerState();
}

class _drawerState extends State<drawer> {
  void onProfileTap() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ));
  }

  void onLogOutTap() async {
    Navigator.pop(context);
    await FirebaseAuth.instance.signOut();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ));
  }

  void onHomeTap() async {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const FetchData(),
        ));
  }

  void onDarkModeTap() async {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        //header
        Column(
          children: [
            const DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),

            SizedBox(
              height: 30,
            ),

            //home list tile
            MyListTile(
              icons: Icons.home,
              text: "H O M E",
              onTap: onHomeTap,
            ),

            // profile list tile
            MyListTile(
              icons: Icons.person,
              text: "P R O F I L E",
              onTap: onProfileTap,
            ),
          ],
        ),

        // logout
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyListTile(
              icons: Icons.dark_mode,
              text: "D A R K  M O D E",
              onTap: onDarkModeTap,
            ),
            MyListTile(
              icons: Icons.logout,
              onTap: onLogOutTap,
              text: "L O G O U T",
            ),
          ],
        )
      ]),
    );
  }
}
