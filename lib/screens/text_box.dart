import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String SectionName;
  final void Function()? onPressed;

  const MyTextBox({super.key, required this.SectionName, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // setion name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                SectionName,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),

              //edit button
              IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),

          //text
          Text(text),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
