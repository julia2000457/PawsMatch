import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_adoption_ui/firebase/chat_messages%5B1%5D.dart';
import 'package:flutter_pet_adoption_ui/firebase/pet_details.dart';
import 'package:flutter_pet_adoption_ui/models/pet_model.dart';
import 'package:flutter_pet_adoption_ui/screens/adopt_pet_screen.dart';
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
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AdoptPetScreen(pet: pets[0]),
                ),
              );
            },
            child: Padding(
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
                        ),
                        image: DecorationImage(
                          image: AssetImage(pets[0].imageUrl),
                          fit: BoxFit.cover,
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
                      animals['breed'].toString(),
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  Widget topBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 50.0, top: 10.0),
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      height: 40.0,
                      width: 40.0,
                      image: AssetImage(owner.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.only(left: 300.0, top: 0.0),
                icon: Icon(
                  Icons.message,
                  color: Color(0xFFFD6456),
                  size: 40.0,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatMessages(),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0),
                child: TextField(
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 22.0,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 30.0),
                      child: Icon(
                        Icons.add_location,
                        color: Color(0xFFFD6456),
                        size: 40.0,
                      ),
                    ),
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 0.0),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
                child: Divider(),
              ),
              Container(
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    SizedBox(width: 40.0),
                    Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        onPressed: () => print('Filters'),
                        icon: Icon(
                          Icons.filter_list,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          topBar(),
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: dbRef.snapshots(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SliverToBoxAdapter(
                  child: CircularProgressIndicator(),
                );
              }

              List<DocumentSnapshot<Map<String, dynamic>>> documents =
                  snapshot.data?.docs ?? [];

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    Map<String, dynamic> animals =
                        documents[index].data() ?? {};
                    animals['key'] = documents[index].id;
                    return listItem(animals: animals);
                  },
                  childCount: documents.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
