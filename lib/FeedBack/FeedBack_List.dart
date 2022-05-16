import 'package:campus/FeedBack/Feedback_Details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedbackDisplay extends StatefulWidget {
  const FeedbackDisplay({Key? key, id}) : super(key: key);

  @override
  State<FeedbackDisplay> createState() => _FeedbackDisplayState();
}

class _FeedbackDisplayState extends State<FeedbackDisplay> {
  final Stream<QuerySnapshot> placeStream =
      FirebaseFirestore.instance.collection('Feedback').snapshots();

  CollectionReference feedback =
      FirebaseFirestore.instance.collection('Feedback');
  Future<void> deletePlace(id) {
    // print("User Deleted $id");
    return feedback
        .doc(id)
        .delete()
        .then((value) => print('Feedback Message Deleted'))
        .catchError((error) => print('Failed to Feedback Message: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
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
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                // String name = storedocs[index]['Name'];
                String feedback1 = storedocs[index]['FeedbackMessage'];
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
                        // builder: (context) => UpdateStudentPage(
                        //   id: storedocs[index]['id'],
                        // ),
                        builder: (context) =>
                            FeedBackDetails(id: storedocs[index]['id']),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                      feedback1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
