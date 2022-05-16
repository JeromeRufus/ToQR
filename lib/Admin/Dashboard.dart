import 'package:campus/Admin/AddPlace.dart';
import 'package:campus/Admin/Listplace.dart';
import 'package:campus/FeedBack/FeedBackForm.dart';
import 'package:campus/FeedBack/FeedBack_List.dart';
import 'package:campus/FeedBack/Feedback_Details.dart';
import 'package:campus/FeedBack/Mange_Feedback.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DateTime timeBackPressed = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        Navigator.of(context)
            .push(MaterialPageRoute(builder: ((context) => Manage_Feedback())));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);
        timeBackPressed = DateTime.now();
        if (isExitWarning) {
          const message = "Tap again to exit";
          Fluttertoast.showToast(
              msg: message,
              fontSize: 15,
              textColor: Colors.grey[900],
              backgroundColor: Colors.grey[300]);
          return false;
        } else {
          Fluttertoast.cancel();
          return true;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Theme(
              data: Theme.of(context).copyWith(
                textTheme: TextTheme().apply(
                  bodyColor: Colors.white,
                ),
                dividerColor: Colors.black,
                iconTheme: IconThemeData(color: Colors.white),
              ),
              child: PopupMenuButton<int>(
                // backgroundcolor:Colors.grey,
                color: Colors.black,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 0,
                    child: Text("Manage Feedback"),
                  ),
                ],
                onSelected: (item) => SelectedItem(context, item),
              ),
            ),
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text('Dashboard'),
            ],
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 20.0),
            child: ListplacePage(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 10.0,
          child: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddplacePage()));
          },
        ),
      ),
    );
  }
}
