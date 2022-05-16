import 'package:campus/Admin/Authentication.dart';
import 'package:campus/Admin/Dashboard.dart';
import 'package:campus/Admin/Reset_Password.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();
  late bool newuser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_already_login();
  }

  void check_if_already_login() async {
    print(newuser);
    if (newuser == false) {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  void dispose() {
    _emailContoller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  TextEditingController _emailContoller = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Form(
              key: _key,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 100, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 200.0,
                      child: Image.asset(
                        'assets/images/SjcLogo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      'Admin Login',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(height: 30),
                        TextFormField(
                          cursorHeight: 20,
                          controller: _emailContoller,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Email cannot be empty';
                            } else {
                              return null;
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            /*contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),*/
                            labelStyle: TextStyle(color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                          ),
                          style: TextStyle(color: Colors.black),
                        ),
                        SizedBox(height: 30),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password cannot be empty';
                            } else
                              return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.red),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                            ),
                          ),
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: 300,
                              height: 50,
                              child: FlatButton(
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: 'RobotoSlab'),
                                ),
                                onPressed: () {
                                  //  if (_emailContoller != '' && _passwordController != '') {
                                  //   print('Successfull');
                                  //   logindata.setBool('login', false);
                                  //   logindata.setString('username', email);
                                  //   Navigator.push(context,
                                  //       MaterialPageRoute(builder: (context) => MyDashboard()));
                                  // }
                                  // },
                                  if (_key.currentState!.validate()) {
                                    signInUser();
                                  }
                                },
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => (ResetScreen()))),
                                child: Text("Forget Password?"))
                          ],
                        )
                      ],
                    ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signInUser() async {
    dynamic authResult =
        await _auth.loginUser(_emailContoller.text, _passwordController.text);
    if (authResult == null) {
      const message = "Incorrect Email or Password";
      Fluttertoast.showToast(
          msg: message,
          fontSize: 15,
          textColor: Colors.black,
          backgroundColor: Colors.grey[300]);
    } else {
      _emailContoller.clear();
      _passwordController.clear();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }
}
