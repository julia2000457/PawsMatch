import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_adoption_ui/firebase/pet_details.dart';
//import 'package:flutter_firebase_series/screens/update_record.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('Animals');

  Widget listItem({required Map<String, dynamic> animals}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 40.0, bottom: 30.0, right: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Hero(
            tag: animals.keys,
            child: Container(
              width: double.infinity,
              height: 250.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                  // ),
                  // image: DecorationImage(
                  //   image: AssetImage(pets[1].imageUrl),
                  //   fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 12.0, 40.0, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  animals['pet_name'],
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.favorite_border),
                  iconSize: 30.0,
                  color: Color(0xFFFD6456),
                  onPressed: () => print('Favorite ${animals}'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.0, 0.0, 40.0, 12.0),
            child: Text(
              animals['description'].toString(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => InsertData(),
                ),
              );
            },
          ),
        ],
      ),
    );

    // color: Colors.amberAccent,
    // child: Padding(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Text(
    //       animals['pet_name'].toString(),
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    //     ),
    //     const SizedBox(
    //       height: 5,
    //     ),
    //     Text(
    //       animals['age'].toString(),
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    //     ),
    //     const SizedBox(
    //       height: 5,
    //     ),
    //     Text(
    //       animals['breed'].toString(),
    //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    //     ),
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.end,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     GestureDetector(
    //       onTap: () {
    //         Navigator.push(
    //           context,
    //           MaterialPageRoute(
    //             builder: (_) => UpdateRecord(animalsKey: animals['key']),
    //           ),
    //         );
    //       },
    //       child: Row(
    //         children: [
    //           Icon(
    //             Icons.edit,
    //             color: Theme.of(context).primaryColor,
    //           ),
    //         ],
    //       ),
    //     ),
    //     const SizedBox(
    //       width: 6,
    //     ),
    //     GestureDetector(
    //       onTap: () {
    //         dbRef.doc(animals['key']).delete();
    //       },
    //       child: Row(
    //         children: [
    //           Icon(
    //             Icons.delete,
    //             color: Colors.red[700],
    //           ),
    //         ],
    //       ),
    //     ),
    //   ],
    // )
    //     ],
    //   ),
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('home2'),
      ),
      body: Container(
        height: double.infinity,
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: dbRef.snapshots(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<DocumentSnapshot<Map<String, dynamic>>> documents =
                snapshot.data?.docs ?? [];

            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> animals = documents[index].data() ?? {};
                animals['key'] = documents[index].id;
                return listItem(animals: animals);
              },
            );
          },
        ),
      ),
    );
  }
}
