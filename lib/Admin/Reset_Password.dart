import 'package:campus/Admin/Authentication.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  var resetpasswordController = TextEditingController();

  final TextEditingController _emailContoller = TextEditingController();
  late String _email;
  final auth = FirebaseAuth.instance;

  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              // decoration: InputDecoration(
              //   hintText: 'Admin Email ID'
              // ),
              decoration: InputDecoration(
                labelText: 'Enter Admin Email ID ',
                labelStyle: TextStyle(fontSize: 20.0),
                border: OutlineInputBorder(),
                // errorStyle:
                //     TextStyle(color: Colors.redAccent, fontSize: 15),
              ),
              //  controller: resetpasswordController,
              // validator: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Please Enter Description';
              //   }
              //   return null;
              // },
              onChanged: (value) {
                setState(() {
                  _email = value.trim();
                });
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RaisedButton(
                child: Text('Send Request'),
                textColor: Colors.white,
                onPressed: () async {
                  await auth.sendPasswordResetEmail(email: _email.trim());
                  const message = "Reset Password sented to our mail";
                  Fluttertoast.showToast(
                    msg: message,
                    fontSize: 15,
                    textColor: Colors.grey[900],
                    backgroundColor: Colors.grey[300],
                  );
                },
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
