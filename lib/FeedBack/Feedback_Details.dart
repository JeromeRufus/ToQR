import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedBackDetails extends StatefulWidget {
  final String id;

  FeedBackDetails({Key? key, required this.id}) : super(key: key);

  @override
  _FeedBackDetailsState createState() => _FeedBackDetailsState();
}

class _FeedBackDetailsState extends State<FeedBackDetails> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  CollectionReference place = FirebaseFirestore.instance.collection('Feedback');

  Future<void> dataPlace(
    id,
    FeedbackMessage,
  ) {
    return place.doc(id).update({
      'FeedbackMessage': FeedbackMessage,
    });
    //.then((value) => print("User Updated"))
    //.catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback Details"),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Feedback')
                .doc(widget.id)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                print('Something Went Wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              var data = snapshot.data!.data();
              var FeedbackMessage = data!['FeedbackMessage'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: FeedbackMessage,
                        readOnly: true,
                        minLines: 20,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: false,
                        onChanged: (value) => FeedbackMessage = value,
                        decoration: const InputDecoration(
                          labelText: 'Feedback: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          )),
    );
  }
}
