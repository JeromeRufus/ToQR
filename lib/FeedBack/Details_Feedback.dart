import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Details_Feedback extends StatefulWidget {
  final String id;
  Details_Feedback({Key? key, required this.id}) : super(key: key);

  @override
  _Details_FeedbackState createState() => _Details_FeedbackState();
}

class _Details_FeedbackState extends State<Details_Feedback> {
  final _formKey = GlobalKey<FormState>();

  CollectionReference students =
      FirebaseFirestore.instance.collection('Feedback');

  Future<void> updateUser(
    id,
    FeedbackMessage,
  ) {
    return students
        .doc(id)
        .update({
          'FeedbackMessage': FeedbackMessage,
        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback update"),
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
              //var password = data['password'];
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: FeedbackMessage,
                        minLines: 20,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: false,
                        onChanged: (value) => FeedbackMessage = value,
                        decoration: const InputDecoration(
                          labelText: 'Feedback ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Feedback message';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     // Validate returns true if the form is valid, otherwise false.
                          //     if (_formKey.currentState!.validate()) {
                          //       updateUser(
                          //         widget.id,
                          //         FeedbackMessage,
                          //       );
                          //       Navigator.pop(context);
                          //     }
                          //   },
                          //   // child: const Text(
                          //   //   'Update',
                          //   //   style: TextStyle(fontSize: 18.0),
                          //   // ),
                          // ),
                          // ElevatedButton(
                          //   onPressed: () => {},
                          //   child: const Text(
                          //     'Reset',
                          //     style: TextStyle(fontSize: 18.0),
                          //   ),
                          //   style: ElevatedButton.styleFrom(
                          //       primary: Colors.blueGrey),
                          // ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )),
    );
  }
}
