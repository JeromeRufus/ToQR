import 'package:campus/Admin/Updateplace.dart';
import 'package:campus/Admin/printqr.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ListplacePage extends StatefulWidget {
  ListplacePage({Key? key}) : super(key: key);

  @override
  _ListplacePageState createState() => _ListplacePageState();
}

class _ListplacePageState extends State<ListplacePage> {
  final Stream<QuerySnapshot> placeStream =
      FirebaseFirestore.instance.collection('Place').snapshots();

  // For Deleting User
  CollectionReference place = FirebaseFirestore.instance.collection('Place');
  Future<void> deletePlace(id) {
    // print("User Deleted $id");
    return place
        .doc(id)
        .delete()
        .then((value) => print('User Deleted'))
        .catchError((error) => print('Failed to Delete user: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: placeStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          print('Something went Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        final List storedocs = [];
        snapshot.data?.docs.map((DocumentSnapshot document) {
          Map a = document.data() as Map<String, dynamic>;
          storedocs.add(a);
          a['id'] = document.id;
        }).toList();

        return Padding(
          padding: EdgeInsets.only(top: 18.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 16.0,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              //var noteInfo = snapshot.data!.docs[index].data()!;
              // String docID = snapshot.data!.docs[index].id;
              String name = storedocs[index]['name'];
              String description = storedocs[index]['description'];
              return Ink(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => UpdateplacePage(
                        id: storedocs[index]['id'],
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PrintQR(id: storedocs[index]['id']),
                            ),
                          );
                        },
                        icon: Icon(
                          Icons.qr_code,
                          color: Colors.black,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deletePlace(storedocs[index]['id']);
                        },
                        icon: Icon(
                          Icons.delete,
                          size: 25.0,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
