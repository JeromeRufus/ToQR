import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../app_large_text.dart';

class FeedbackForm extends StatefulWidget {
  FeedbackForm({Key? key}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  DateTime timeBackPressed = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  var FeedbackMessage = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final FeedbackMessageController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    FeedbackMessageController.dispose();
    super.dispose();
  }

  clearText() {
    FeedbackMessageController.clear();
  }

  CollectionReference students =
      FirebaseFirestore.instance.collection('Feedback');

  Future<void> addUser() {
    return students
        .add({
          'FeedbackMessage': FeedbackMessage,
        })
        .then((value) => print('Feedback Message Added'))
        .catchError((error) => print('Failed to Add Feedback Message: $error'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: ListView(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    AppLargeText(
                      text: "FeedBack",
                      //size: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
                child: Text(
                  "Leave us a message and we'll get in contact with you as soon as possible. ",
                  style: TextStyle(
                    fontSize: 17.5,
                    height: 1.3,
                    fontFamily: 'RobotoSlab',
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: TextFormField(
                  minLines: 5,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: false,
                  decoration: const InputDecoration(
                    fillColor: Color(0xffe6e6e6),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 35, horizontal: 20),
                    hintText: 'Your Feedback',
                    hintStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontFamily: 'RobotoSlab',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(17),
                      ),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  controller: FeedbackMessageController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Enter Your Feedback';
                    }
                    return null;
                  },
                ),
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 350,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () {
                          // if()
                          // Validate returns true if the form is valid, otherwise false.
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              FeedbackMessage = FeedbackMessageController.text;
                              addUser();
                              clearText();
                              const message = "Feedback sent";
                              Fluttertoast.showToast(
                                  msg: message,
                                  fontSize: 15,
                                  textColor: Colors.grey[900],
                                  backgroundColor: Colors.grey[300]);
                            });
                          }
                        },
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const Center(
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              const Center(
                                  child: Text(
                                "Send",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'RobotoSlab'),
                              )),
                            ],
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black87,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15.0))),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
