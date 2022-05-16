import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddplacePage extends StatefulWidget {
  const AddplacePage({Key? key}) : super(key: key);

  @override
  _AddplacePageState createState() => _AddplacePageState();
}

class _AddplacePageState extends State<AddplacePage> {
  final _formKey = GlobalKey<FormState>();

  String imageName = "";
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  //var imageController=imagePicker();
  FirebaseStorage storageRef = FirebaseStorage.instance;
  FirebaseFirestore firestoreRef = FirebaseFirestore.instance;
  //FirebaseFirestore firestoreRef = FirebaseStorage.instance as FirebaseFirestore;
  bool _isLoading = false;
  String collectionName = "Place";

  var name = "";
  var description = "";

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    //imagePath.dispose();
    super.dispose();
  }

  clearText() {
    nameController.clear();
    descriptionController.clear();
    //imagePath.clear();
  }

  clearimage() {
    setState(() {
      imagePath;
      imageName;
    });
  }

  //CollectionReference place = FirebaseFirestore.instance.collection('Place');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Place"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Name: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        controller: nameController,
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      //child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        minLines: 10,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: 'Description: ',
                          labelStyle: TextStyle(fontSize: 20.0),
                          border: OutlineInputBorder(),
                          errorStyle:
                              TextStyle(color: Colors.redAccent, fontSize: 15),
                        ),
                        controller: descriptionController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          imageName == "" ? Container() : Text(imageName),
                          OutlinedButton(
                              onPressed: () {
                                imagePicker();
                              },
                              child: Text("Select image")),
                        ],
                      ),
                    )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, otherwise false.
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  name = nameController.text;
                                  description = descriptionController.text;
                                  //addPlace();
                                  _uploadImage();
                                  clearText();
                                  clearimage();
                                  //_uploadImage();
                                });
                              }
                            },
                            //  child:_isLoading ? const Center(child: CircularProgressIndicator(color: Colors.red,)):(
                            child: Text(
                              'Add',
                              style: TextStyle(fontSize: 18.0),
                            )
                            // ),
                            ),
                        ElevatedButton(
                          onPressed: () => {clearText(), clearimage()},
                          child: Text(
                            'Reset',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.blueGrey),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  _uploadImage() async {
    setState(() {
      _isLoading = true;
    });

    var uniqueKey = firestoreRef.collection(collectionName).doc();
    String uploadFileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpeg';
    Reference reference = storageRef.ref().child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));

    uploadTask.snapshotEvents.listen(((event) {
      print(event.bytesTransferred.toString() +
          "\t" +
          event.totalBytes.toString());
    }));

    await uploadTask.whenComplete(() async {
      var uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      if (uploadPath.isNotEmpty) {
        List<String> splitList = name.split(' ');
        List<String> indexList = [];
        for (int i = 0; i < splitList.length; i++) {
          for (int j = 0; j < splitList[i].length; j++) {
            indexList.add(splitList[i].substring(0, j).toLowerCase());
          }
        }
        firestoreRef.collection(collectionName).doc(uniqueKey.id).set({
          "name": name,
          "description": description,
          "image": uploadPath,
          "searchkey": indexList,
        }).then((value) => _showMessage("Place inserted"));
      } else {
        _showMessage("Something happend while uploading Image");
      }

      setState(() {
        _isLoading = false;
        // descriptionController.text=description;
        //nameController.text=name;
        //imageName=imageName;
      });
    });
  }

  _showMessage(String msg) {
    const message = "Record Inserted";
    //ToastGravity.BOTTOM_RIGHT;
    Fluttertoast.showToast(
      msg: message,
      fontSize: 15,
      textColor: Colors.grey[900],
      backgroundColor: Colors.grey[300],
    );
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(msg),
    //   duration: const Duration(seconds: 3),
    // ));
  }

  imagePicker() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
        name = nameController.text;
        description = descriptionController.text;
      });
    }
  }
}
