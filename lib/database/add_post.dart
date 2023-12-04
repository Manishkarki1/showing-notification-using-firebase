import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController postController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: postController,
              decoration: InputDecoration(
                hintText: 'Write Something',
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                String id = DateTime.now().millisecond.toString();
                databaseRef.child(id).set({
                  'id': id,
                  'details': postController.text.toString()
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 1),
                      content: Text('post Added')));
                }).onError((error, stackTrace) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(error.toString())));
                });
              },
              child: Text('Add'))
        ],
      ),
    );
  }
}
