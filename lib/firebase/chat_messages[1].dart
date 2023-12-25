import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_pet_adoption_ui/firebase/new_message%5B1%5D.dart';
import 'package:flutter_pet_adoption_ui/screens/home_screen.dart';

class ChatMessages extends StatefulWidget {
  const ChatMessages({Key? key}) : super(key: key);

  @override
  _ChatMessagesState createState() => _ChatMessagesState();
}

class _ChatMessagesState extends State<ChatMessages> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Messages'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NewMessage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle searching logic here
              print('Search button clicked!');
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        // Establish the database connection in a Future
        future: _initializeDatabaseConnection(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .orderBy('createdAt', descending: false)
                  .snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshots) {
                if (chatSnapshots.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!chatSnapshots.hasData || chatSnapshots.data == null) {
                  return const Center(
                    child: Text('No messages found.'),
                  );
                }

                final loadedMessages = chatSnapshots.data!.docs;

                return ListView.builder(
                  itemCount: loadedMessages.length,
                  itemBuilder: (ctx, index) {
                    // final username = messageData['username'];
                    // final text = messageData['text'];

                    // return _buildChatMessage(username, text);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _initializeDatabaseConnection() async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'messages') // You can replace this with your actual collection
          .doc('2mHu6Jx3bjZtN68eRqvY')
          .get();
      // The above operation is just to check the connection
    } catch (e) {
      // Handle the exception (e.g., show an error message)
      print('Error establishing database connection: $e');
      throw Exception('Failed to establish database connection');
    }
  }

  Widget _buildChatMessage(String username, String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
