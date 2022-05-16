import 'package:campus/FeedBack/FeedBack_List.dart';
import 'package:flutter/material.dart';

class Manage_Feedback extends StatefulWidget {
  const Manage_Feedback({Key? key}) : super(key: key);

  @override
  State<Manage_Feedback> createState() => _Manage_FeedbackState();
}

class _Manage_FeedbackState extends State<Manage_Feedback> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Manage Feedback'),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
          child: FeedbackDisplay(),
        ),
      ),
    );
  }
}
