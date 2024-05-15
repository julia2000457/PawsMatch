import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final IconData icons;
  final String text;
  final void Function()? onTap;

  const MyListTile(
      {super.key,
      required this.icons,
      required this.text,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: ListTile(
        leading: Icon(
          icons,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        
      ),
    );
  }
}
