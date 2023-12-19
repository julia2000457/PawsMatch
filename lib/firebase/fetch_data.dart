import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_adoption_ui/firebase/pet_details.dart';
import 'package:flutter_pet_adoption_ui/models/pet_model.dart';
//import 'package:flutter_firebase_series/screens/update_record.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  CollectionReference<Map<String, dynamic>> dbRef =
      FirebaseFirestore.instance.collection('Animals');
  Widget _buildPetCategory(bool isSelected, String category) {
    return GestureDetector(
      onTap: () => print('Selected $category'),
      child: Container(
        margin: EdgeInsets.all(10.0),
        width: 80.0,
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFD6456) : Color(0xFFF8F2F7),
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected
              ? Border.all(
                  width: 8.0,
                  color: Color(0xFFFED8D3),
                )
              : null,
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

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
                ),
                image: DecorationImage(
                  image: AssetImage(pets[1].imageUrl),
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
              animals['description'].toString(),
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 16.0,
                color: Color.fromARGB(255, 0, 0, 0),
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

  Widget topBar() {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Your App Title'),
        background: Container(
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 40.0, top: 40.0),
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
              SizedBox(height: 40.0),
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
                        color: const Color.fromARGB(255, 189, 5, 5),
                        size: 40.0,
                      ),
                    ),
                    labelText: 'Location',
                    labelStyle: TextStyle(
                      fontSize: 20.0,
                      color: Color.fromARGB(255, 142, 17, 137),
                    ),
                    contentPadding: EdgeInsets.only(bottom: 20.0),
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
                    _buildPetCategory(false, 'Cats'),
                    _buildPetCategory(true, 'Dogs'),
                    _buildPetCategory(false, 'Birds'),
                    _buildPetCategory(false, 'Other'),
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
          // _buildPetCategory(true, 'Dogs'),
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
