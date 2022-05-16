import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateplacePage extends StatefulWidget {
  final String id;

  UpdateplacePage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  _UpdateplacePageState createState() => _UpdateplacePageState();
}

class _UpdateplacePageState extends State<UpdateplacePage> {
  final _formKey = GlobalKey<FormState>();

  var name = "";
  var description = "";

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();

  CollectionReference place = FirebaseFirestore.instance.collection('Place');

  Future<void> updatePlace(
    id,
    name,
    description,
    List<String> indexList,
  ) {
    return place
        .doc(id)
        .update({
          'name': name,
          'description': description,
          "searchkey": indexList,
        })
        .then((value) => print("Place Updated"))
        .catchError((error) => print("Failed to update Place: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Update Place"),
      ),
      body: Form(
          key: _formKey,
          // Getting Specific Data by ID
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Place')
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
              var name = data!['name'];
              var description = data['description'];

              return Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: ListView(
                  children: [
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: name,
                        autofocus: false,
                        onChanged: (value) => name = value,
                        decoration: const InputDecoration(
                          labelText: 'Name: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        initialValue: description,
                        minLines: 20,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: false,
                        onChanged: (value) => description = value,
                        decoration: const InputDecoration(
                          labelText: 'description: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                List<String> splitList = name.split(' ');
                                List<String> indexList = [];
                                for (int i = 0; i < splitList.length; i++) {
                                  for (int j = 0;
                                      j < splitList[i].length;
                                      j++) {
                                    indexList.add(splitList[i]
                                        .substring(0, j)
                                        .toLowerCase());
                                  }
                                }
                                updatePlace(
                                  widget.id,
                                  name,
                                  description,
                                  indexList,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
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
