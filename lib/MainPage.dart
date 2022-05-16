import 'package:campus/FeedBack/FeedBackForm.dart';
import 'package:campus/HomePage.dart';
import 'package:campus/navigationbar/Direction.dart';
import 'package:campus/navigationbar/search_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  DateTime timeBackPressed = DateTime.now();
  int _currentIndex = 0;
  final List<Widget> _children = [
    MyHomePage(),
    Search_Page(),
    Direction(),
    FeedbackForm()
  ];
  //final List<Widget> _children
  void onTapperBar(int index) {
    setState(() {
      _currentIndex = index;
      if (index == 2) {
        double Latitude = 10.829922;
        double Longitude = 78.690439;
        launch(
            'https:/www.google.com/maps/search/?api=1&query=$Latitude,$Longitude');
        _currentIndex = index;
      }
    });
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      //  body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTapperBar,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black54,
        //backgroundColor: Color(0xFFf1f5fb),
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showUnselectedLabels: false,
        // showSelectedLabels: false,
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search place'),
          BottomNavigationBarItem(
              icon: Icon(Icons.directions), label: 'Direction'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback), label: 'feedback')
        ],
      ),
    );
  }
}
