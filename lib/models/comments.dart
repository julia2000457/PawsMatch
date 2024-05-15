import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String text;
  final String user;
  final String time;

  const Comment({
    Key? key,
    required this.text,
    required this.user,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
      width: double.infinity,
      height: 90.0,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 243, 208, 208),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.vertical,
        children: [
          Padding(
            padding: EdgeInsets.all(
              20
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontFamily: 'Montserrat',
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.start,
            ),
          ),

          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.only(bottom: 10, left: 10, right: 10),), 
              Text(
                user,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.right,
              ),
              
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
