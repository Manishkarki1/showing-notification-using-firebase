import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasepractice/database/add_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomeScreenPhone extends StatefulWidget {
  const HomeScreenPhone({super.key});

  @override
  State<HomeScreenPhone> createState() => _HomeScreenPhoneState();
}

class _HomeScreenPhoneState extends State<HomeScreenPhone> {
  final auth = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  TextEditingController searchController = TextEditingController();
  TextEditingController editController = TextEditingController();
  Future<void> showMyDialog(String content, String id) async {
    editController.text = content;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Update'),
            content: Container(
              child: TextFormField(controller: editController, autofocus: true),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    databaseRef.child(id).update({
                      'details': editController.text.toLowerCase()
                    }).then((value) {
                      return Fluttertoast.showToast(
                          msg: 'successfully updated',
                          backgroundColor: Colors.green,
                          toastLength: Toast.LENGTH_SHORT);
                    }).onError((error, stackTrace) {
                      return Fluttertoast.showToast(
                          msg: error.toString(),
                          backgroundColor: Colors.red,
                          toastLength: Toast.LENGTH_SHORT);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home screen'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red.withOpacity(0.5),
          onPressed: () {
            print('hey');
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddPost()));
          },
          child: Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 1,
                controller: searchController,
                autocorrect: false,
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide())),
              ),
            ),
            Expanded(
              //using streambuilder
              // child: StreamBuilder(
              //   stream: databaseRef.onValue,
              //   builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
              //     if (!snapshot.hasData) {
              //       return CircularProgressIndicator();
              //     } else {
              //       Map<dynamic, dynamic> map =
              //           snapshot.data?.snapshot.value as dynamic;
              //       List<dynamic> list = [];
              //       list.clear();
              //       list = map.values.toList();

              //       return ListView.builder(
              //         itemCount: snapshot.data?.snapshot.children.length,
              //         itemBuilder: (context, index) {
              //           return ListTile(
              //             title: Text(list[index]['details']),
              //           );
              //         },
              //       );
              //     }
              //   },
              // ),
              // ),

              //using the firebaseanimatedlist widget
              child: FirebaseAnimatedList(
                  query: databaseRef,
                  itemBuilder: (context, snapshot, animation, index) {
                    final details = snapshot.child('details').value.toString();
                    final id = snapshot.child('id').value.toString();
                    if (searchController.text.isEmpty) {
                      return ListTile(
                        leading: Text("${index.toString()}"),
                        title: Text("$details"),
                        trailing: PopupMenuButton(
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.edit),
                                  title: Text('edit'),
                                ),
                                onTap: () {
                                  showMyDialog(details, id);
                                },
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Delete'),
                                ),
                                onTap: () {
                                  databaseRef.child(id).remove();
                                  Fluttertoast.showToast(
                                      msg: 'Succesfully deleted',
                                      backgroundColor: Colors.red,
                                      toastLength: Toast.LENGTH_SHORT);
                                },
                              ),
                            ];
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      );
                    } else if (details
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return ListTile(
                        leading: Text("${index.toString()}"),
                        title: Text("$details"),
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
